%% Detect balls using feature detection method
clc;
close all;
clear all;

% %% Read Image
% I = imread('./data/exp1/Tension11.jpg');
% I = sum(double(I),3)/255.0/3.0;     % to grayscaled image


%% Calculate pixel scale
% Detect checkerboard pattern in image
imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop"),...
    "IncludeSubfolders",true,"FileExtensions",".jpg","LabelSource","foldernames")

Fig.T11 = readimage(imds,1); % Figure of the tension 1:1
Fig.T12 = readimage(imds,2); % Figure of the tension 1:2
Fig.T13 = readimage(imds,3); % Figure of the tension 1:3
Fig.T21 = readimage(imds,4); % Figure of the tension 2:1
Fig.T31 = readimage(imds,5); % Figure of the tension 3:1

% Detect checkerboard pattern in the images
N = length(imds.Files);
[imagePoints,boardSize,imageUsed] = detectCheckerboardPoints(imds.Files(1:N));

rows = zeros(size(imagePoints,1),N);
cols = zeros(size(imagePoints,1),N);

for i = 1:N
    checkerboard{i}.img = readimage(imds,i);
    checkerboard{i}.img = insertText(checkerboard{i}.img,imagePoints(:,:,i),1:size(imagePoints,1));
    checkerboard{i}.img = insertMarker(checkerboard{i}.img, imagePoints(:,:,i), 'o', 'Color', 'red', 'Size', 10);
    
%     rows(:,i) = imagePoints(:,1,i);
%     cols(:,i) = imagePoints(:,2,i);
    
%     imshow(checkerboard{1,1}.img);
end

% Calculate the length of square (checkerboard size = 7x8, square size = 10mm)
rows = reshape(imagePoints(:,1,:), 6, 7, []);
cols = reshape(imagePoints(:,2,:), 6, 7, []);


squareSizePX = zeros(1, N);
for i = 1:N
    drows_row = diff(rows(:,:,i));
    dcols_row = diff(cols(:,:,i));

    drows_col = diff(rows(:,:,i)')';
    dcols_col = diff(cols(:,:,i)')';

    diff_row = sqrt(drows_row.^2 + dcols_row.^2);
    diff_col = sqrt(drows_col.^2 + dcols_col.^2);

    squareSizePX(i) = 0.5 * (mean(diff_row(:)) + mean(diff_col(:)));

    % report camera alignment
    disp(['Image ', num2str(i), ': Camera view is ',...
        num2str(mean(diff_row(:)) / mean(diff_col(:)) * 100), '% aligned with plane.'])
end

squareSizeMM = 10;

to_mm = squareSizeMM./squareSizePX;
to_pixel = squareSizePX./squareSizeMM;




%% Detect Links
p_frame = cell(1, N);

for k = 1:N

    %% Blur image
    
%     I = sum(double(Fig.T11),3)/255.0/3.0; 
    I = readimage(imds,k);
    I = sum(double(I),3)/255.0/3.0; 
    
    
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
    
    id_remove = points.Location(:,2) > 2300;
    points(id_remove) = [];
    
    % remove close points
    radius = 10;
    [~, id_remove] = clusterPoints(points.Location, radius);
    points(id_remove) = [];
    
    % % find 3 ponts comprising frames
    axis_length = 5 * to_pixel(k);
    [id_center, frame_points_id] = findFramePoints(points.Location, axis_length);
    
    
    %% Refine ball position
    nFrames = length(frame_points_id);
    p_frame{k} = cell(1, nFrames);
    for i = 1:nFrames
        p_frame{k}{i} = points.Location(frame_points_id{i},:);
    
        w = 15;
        for j = 1:3
            center0 = p_frame{k}{i}(j,:);
            corner = round(center0) - w;
    
            center0 = double(center0 - corner + 1);
           
            img_cropped = I_blur(corner(2):corner(2)+2*w, corner(1):corner(1)+2*w);
            
            center = refineBallPosition(img_cropped, center0, 3);
    
    %         figure
    %         imshow(img_cropped);
    %         hold on
    %         plot(center0(1), center0(2), 'rx')
    %         plot(center(1), center(2), 'bx')
    
            
            p_frame{k}{i}(j,:) = center + corner - 1;
        end
    
        % correct x- and y-axes
        xVec = p_frame{k}{i}(2,:) - p_frame{k}{i}(1,:);
        yVec = p_frame{k}{i}(3,:) - p_frame{k}{i}(1,:);
        cross_xy = xVec(1) * yVec(2) - xVec(2) * yVec(1);
        if (cross_xy > 0)
            p_frame{k}{i}([2,3],:) = p_frame{k}{i}([3,2],:);
        end
    
    
    end
    
    
    %% Remove false frames
    id_falseFrame = [];
    
    for i = 1:nFrames
    
        xVec = p_frame{k}{i}(2,:) - p_frame{k}{i}(1,:);
        yVec = p_frame{k}{i}(3,:) - p_frame{k}{i}(1,:);
        inner_xy = (xVec(1) * yVec(1) + xVec(2) * yVec(2)) / norm(xVec) / norm(yVec);
        
        if (abs(norm(xVec) - axis_length) > 0.1 * axis_length || abs(norm(yVec) - axis_length) > 0.1 * axis_length || abs(inner_xy) > 0.1)
            id_falseFrame = [id_falseFrame, i];
        end
    
    end
    
    p_frame{k}(id_falseFrame) = [];
    nFrames = length(p_frame{k});
    
    
    %% Sort frame from base to tip
    dist_to_base = zeros(1, nFrames);
    for i = 1:nFrames
        dist_to_base(i) = norm(p_frame{k}{i}(1,:) - [1050, 2275]);
    end

    [~, id_sort] = sort(dist_to_base);

    p_frame{k} = p_frame{k}(id_sort);


%     if k ~= 2 && k ~= 3
%         p_frame{k} = p_frame{k}(nFrames:-1:1);
%     end


    %% Plot
    figure
    imshow(I);
    hold on;
    plot(points)
    
    for i = 1:nFrames
        p = p_frame{k}{i};
    
    %     plot([p(:,1); p(1,1)], [p(:,2); p(1,2)], 'ro-')
        plot(p(1:2,1), p(1:2,2), 'bx-')
        plot(p([1,3],1), p([1,3],2), 'ro-')
    
    end

end

%% Save
save('./imageprocessing/processed_data.mat', 'p_frame', 'to_mm', 'to_pixel');

















