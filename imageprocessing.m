%% Detect checkerboard pattern in image
clc;
clear all;
close all;
addpath('C:\Users\kimcw\Desktop\RollingJoint_main\imageprocessing');

imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop"),...
    "IncludeSubfolders",true,"FileExtensions",".jpg","LabelSource","foldernames")

Fig.T11 = readimage(imds,1); % Figure of the tension 1:1
Fig.T12 = readimage(imds,2); % Figure of the tension 1:2
Fig.T13 = readimage(imds,3); % Figure of the tension 1:3
Fig.T21 = readimage(imds,4); % Figure of the tension 2:1
Fig.T31 = readimage(imds,5); % Figure of the tension 3:1
Fig.test = readimage(imds,6); % marker

% Detect checkerboard pattern in the images
N = length(imds.Files);
[imagePoints,boardSize,imageUsed] = detectCheckerboardPoints(imds.Files(1:N));

rows = zeros(size(imagePoints,1),N);
cols = zeros(size(imagePoints,1),N);

for i = 1:N
    checkerboard{i}.img = readimage(imds,i);
    checkerboard{i}.img = insertText(checkerboard{i}.img,imagePoints(:,:,i),1:size(imagePoints,1));
    checkerboard{i}.img = insertMarker(checkerboard{i}.img, imagePoints(:,:,i), 'o', 'Color', 'red', 'Size', 10);
    
    rows(:,i) = imagePoints(:,1,i);
    cols(:,i) = imagePoints(:,2,i);
    
%     imshow(checkerboard{1,1}.img);
end

%% Calculate the length of square (checkerboard size = 7x8, square size = 10mm)

squareSizeMM = 10;
% worldPoints = generateCheckerboardPoints(boardSize, squareSizeMM);
% imageSize = [size(I,1),size(I,2)];
% params = estimateCameraParameters(imagePoints,worldPoints, ...
%     'ImageSize', imageSize);
% showReprojectionErrors(params);

diffRows = diff(rows(1:6,1));
squareSizePX = mean(diffRows);
pixelSize = squareSizePX/squareSizeMM;

%% Detect the marker
% imshow(Fig.T11);
% d = drawline;
% pos = d.Position;
% diffPos = diff(pos);
% diameter = hypot(diffPos(1),diffPos(2))
% T11_cropped = Fig.T11(1240:2300, 1:2160, :); %(1:2160, 1240:2300);
Fig_test = Fig.test(1240:2350, 1:2160, :);
% figure(1)
% imshow(T11_cropped)
% hold on
% figure(2)
imshow(Fig_test)

redThresh = 0.24;
diffFrameRed = imsubtract(Fig_test(:,:,1), rgb2gray(Fig_test));


% 
% 
% 
% diff_im = imsubtract(

% [centers,radii] = imfindcircles(T11_cropped,[5 6],'ObjectPolarity','dark', ...
%     'Sensitivity',0.96,'Method','Twostage','EdgeThreshold',0.2);
[centersTest,radiiTest] = imfindcircles(Fig_test,[5 6],'ObjectPolarity','dark', ...
    'Sensitivity',0.96,'Method','Twostage','EdgeThreshold',0.2);
% 
% numCircles = length(centers)
% T11_cropped = insertText(T11_cropped,centers,1:size(centers,1));
% imshow(T11_cropped);
% h = viscircles(centers,radii);


numCircles = length(centersTest)
Fig_test = insertText(Fig_test,centersTest,1:size(centersTest,1));
imshow(Fig_test);
h = viscircles(centersTest,radiiTest);




