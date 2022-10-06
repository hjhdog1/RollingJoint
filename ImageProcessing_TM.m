%% Image processing using template matching 
clc;
clear all;
addpath('C:\Users\kimcw\Desktop\RollingJoint_main\imageprocessing');

% Read image files
imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop"),...
    "IncludeSubfolders",true,"FileExtensions",".jpg","LabelSource","foldernames")

Fig.T11 = readimage(imds,1); % Figure of the tension 1:1
Fig.T12 = readimage(imds,2); % Figure of the tension 1:2
Fig.T13 = readimage(imds,3); % Figure of the tension 1:3
Fig.T21 = readimage(imds,4); % Figure of the tension 2:1
Fig.T31 = readimage(imds,5); % Figure of the tension 3:1
Fig.test = readimage(imds,6); % Black marker

Fig_test = Fig.test(1240:2300, 1:2160, :); % Image crop

imshow(Fig_test);
roi = drawrectangle
Pos = roi.Position;
orig = [Pos(1) Pos(2)]; % [x y] upper left corner
width = Pos(3);
height = Pos(4);

%% Template matcher(Image)
I = im2double(Fig_test); % Input image
I = rgb2gray(I);
T = imcrop(I,Pos); % Template image
T = imbinarize(T);
T = double(T);
ROI = Pos; % [x y width height]

tMatcher = vision.TemplateMatcher;
location = tMatcher(I,T);
Fig_test = insertMarker(Fig_test,location,'o','Color','red','size',10);   
figure(1)
imshow(Fig_test)





