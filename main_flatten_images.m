%% Detect balls using feature detection method
clc;
close all;
clear all;

%% Calculate pixel scale
% Detect checkerboard pattern in image
imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop"),...
    "IncludeSubfolders",true,"FileExtensions",".jpg","LabelSource","foldernames")

% Detect checkerboard pattern in the images
N = length(imds.Files);
[imagePoints,boardSize,imageUsed] = detectCheckerboardPoints(imds.Files(1:N));

rows = zeros(size(imagePoints,1),N);
cols = zeros(size(imagePoints,1),N);

for i = 1:N
    checkerboard{i}.img = readimage(imds,i);
    checkerboard{i}.img = insertText(checkerboard{i}.img,imagePoints(:,:,i),1:size(imagePoints,1));
    checkerboard{i}.img = insertMarker(checkerboard{i}.img, imagePoints(:,:,i), 'o', 'Color', 'red', 'Size', 10);

%     imshow(checkerboard{i}.img);
end

%% Flat Grid Fitting
[X, Y] = meshgrid(7:-1:1, 1:6);
modelPoints = [Y(:), X(:)];

for i = 1:N
    [R, t, scale, reporjection] = perform2DRegistration(imagePoints(:,:,i), modelPoints);
    
    I = readimage(imds,i);
    
%     figure
%     imshow(I)
%     hold on
%     plot(reporjection(1,:), reporjection(2,:), 'bx')
    
    %% Calculate homography
    H = homography_solve(imagePoints(:,:,i)', reporjection);
    
    tform = projtform2d(H);
    outputImage = imwarp(I, tform);
    
    figure
    imshow(outputImage)
%     hold on
%     plot(reporjection(1,:), reporjection(2,:), 'bx')
    
    name_array = split(imds.Files{i}, '\');
    imwrite(outputImage, ['./imageprocessing/img/Test1/crop_flat/', name_array{end}]);
end

% y = H * [imagePoints(:,:,1)'; ones(1,42)]; y = y(1:2,:)./y(3,:);
% reporjection - imagePoints(:,:,1)'
% reporjection - y

% %%
% 
% % Calculate the length of square (checkerboard size = 7x8, square size = 10mm)
% rows = reshape(imagePoints(:,1,:), 6, 7, []);
% cols = reshape(imagePoints(:,2,:), 6, 7, []);
% 
% 
% squareSizePX = zeros(1, N);
% for i = 1:N
%     drows_row = diff(rows(:,:,i));
%     dcols_row = diff(cols(:,:,i));
% 
%     drows_col = diff(rows(:,:,i)')';
%     dcols_col = diff(cols(:,:,i)')';
% 
%     diff_row = sqrt(drows_row.^2 + dcols_row.^2);
%     diff_col = sqrt(drows_col.^2 + dcols_col.^2);
% 
%     squareSizePX(i) = 0.5 * (mean(diff_row(:)) + mean(diff_col(:)));
% 
%     % report camera alignment
%     disp(['Image ', num2str(i), ': Camera view is ',...
%         num2str(mean(diff_row(:)) / mean(diff_col(:)) * 100), '% aligned with plane.'])
% end
% 
% squareSizeMM = 10;
% 
% to_mm = squareSizeMM./squareSizePX;
% to_pixel = squareSizePX./squareSizeMM;
% 
