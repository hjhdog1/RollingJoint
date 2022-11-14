%% Detect balls using feature detection method
clc;
close all;
clear all;


%% Paths
sourcePath = "data\exp2";
targetPath = "data\exp2_flatten";


%% Calculate pixel scale
% Detect checkerboard pattern in image
imds = imageDatastore(fullfile(sourcePath,"CheckerBoard"),...
    "FileExtensions",".jpg","LabelSource","foldernames");

% Detect checkerboard pattern in the images
[imagePoints,boardSize,imageUsed] = detectCheckerboardPoints(imds.Files(1));

rows = zeros(size(imagePoints,1));
cols = zeros(size(imagePoints,1));

% Show checkerboard image
checkerboard_img = readimage(imds,1);
checkerboard_img = insertText(checkerboard_img, imagePoints, 1:size(imagePoints,1));
checkerboard_img = insertMarker(checkerboard_img, imagePoints, 'o', 'Color', 'red', 'Size', 10);

imshow(checkerboard_img);


%% Calculate Flattening homography
[X, Y] = meshgrid(boardSize(2)-1:-1:1, boardSize(1)-1:-1:1);
modelPoints = [X(:), Y(:)];

[R, t, scale, reporjection] = perform2DRegistration(imagePoints, modelPoints);

alpha = 1000.0;
H = homography_solve(imagePoints' / alpha, reporjection / alpha);
H = diag([alpha, alpha, 1]) * H / diag([alpha, alpha, 1]);

tform = projtform2d(H);

I = readimage(imds,1);
outputImage = imwarp(I, tform);

% save image
name_array = split(imds.Files{1}, '\');
imwrite(outputImage, targetPath + '\CheckerBoard\' + name_array{end});

% show image
figure
imshow(outputImage)

%% Flatten experiment images
imds_exp = imageDatastore(fullfile(sourcePath),...
    "FileExtensions",".jpg","LabelSource","foldernames");

N = length(imds_exp.Files);
for i = 1:N
    I = readimage(imds_exp,i);
    outputImage = imwarp(I, tform);
    
    % save image
    name_array = split(imds_exp.Files{i}, '\');
    imwrite(outputImage, targetPath + '\' + name_array{end});
end



%% Flat Grid Fitting
[X, Y] = meshgrid(boardSize(2)-1:-1:1, boardSize(1)-1:-1:1);
modelPoints = [X(:), Y(:)];


for i = 1:N
    [R, t, scale, reporjection] = perform2DRegistration(imagePoints(:,:,i), modelPoints);
        
    I = readimage(imds,i);
    
    
    %% Calculate homography
    alpha = 1000.0;
    H = homography_solve(imagePoints(:,:,i)' / alpha, reporjection / alpha);

    H = diag([alpha, alpha, 1]) * H / diag([alpha, alpha, 1]);

    tform = projtform2d(H);
    outputImage = imwarp(I, tform);
    
    figure
    imshow(outputImage)
    
    name_array = split(imds.Files{i}, '\');
    imwrite(outputImage, targetPath + '\CheckerBoard\' + name_array{end});
end



% %% Check result
% y = H * [imagePoints(:,:,1)'; ones(1,size(imagePoints,1))];
% y = y(1:2,:)./y(3,:);
% 
% norm(reporjection - imagePoints(:,:,1)', 'fro')
% norm(reporjection - y, 'fro')

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

