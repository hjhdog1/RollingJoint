%% Detect balls using feature detection method
clc;
close all;
clear all;

%% Read Image
I = imread('./data/exp1/Tension11.jpg');
I = sum(double(I),3)/255.0/3.0;     % to grayscaled image


%% Blur image

% define Mask
n1 = 10;
sig = 3;

% circle mask
c = (n1+1)/2;
mask1 = zeros(n1);
for i = 1:n1
    for j = 1:n1
        mask1(i,j) = exp(-((i-c)^2 + (j-c)^2)/sig^2);
    end
end
mask1 = mask1 / sum(mask1(:));

I_blur = imfilter(I, mask1, 'symmetric');



%% Feature detection

points = detectHarrisFeatures(I);

% remove feature on upper and lower image
id_remove = points.Location(:,2) < 1150;
points(id_remove) = [];

id_remove = points.Location(:,2) >2280;
points(id_remove) = [];

% remove close points
radius = 10;
[~, id_remove] = clusterPoints(points.Location, radius);
points(id_remove) = [];

% % find 3 ponts comprising frames
axis_length = 48.0;
[id_center, frame_points_id] = findFramePoints(points.Location, axis_length);


%% Refine ball position
nFrames = length(frame_points_id);
p_frame = cell(1, nFrames);
for i = 1:nFrames
    p_frame{i} = points.Location(frame_points_id{i},:);

    w = 15;
    for j = 1:3
        center0 = p_frame{i}(j,:);
        corner = round(center0) - w;

        center0 = double(center0 - corner + 1);
       
        img_cropped = I_blur(corner(2):corner(2)+2*w, corner(1):corner(1)+2*w);
        
        center = refineBallPosition(img_cropped, center0, 3);

%         figure
%         imshow(img_cropped);
%         hold on
%         plot(center0(1), center0(2), 'rx')
%         plot(center(1), center(2), 'bx')

        
        p_frame{i}(j,:) = center + corner - 1;
    end

end


%% Plot
figure
imshow(I);
hold on;
plot(points)

for i = 1:nFrames
    p = p_frame{i};

    plot([p(:,1); p(1,1)], [p(:,2); p(1,2)], 'ro-')

end




















