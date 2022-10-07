%% Compare Model and Experiments
clc;
clear all;
close all;


%% Read images
imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop"),...
    "IncludeSubfolders",true,"FileExtensions",".jpg","LabelSource","foldernames");

N = length(imds.Files);

imgs = cell(1,N);
for i = 1:N
    imgs{i} = readimage(imds,i);

    figure
    imshow(imgs{i});
end


%% Load processed data
data = load('./imageprocessing/processed_data.mat');

%% Get Transformations from ball markers
% Since image frame is flipped in y-axis, the determinant of rotation
% matrix is negative, i.e., det(R) = -1.

nLinks = 6;

R = cell(N, nLinks);
t = cell(N, nLinks);

for i = 1:N

    P = [0, 0; 5, 0; 0, 5]' * data.to_pixel(i);

    for j = 1:nLinks
        p = data.p_frame{i}{j};
        Q = (p - mean(p))';

        PQ_trans = P * Q';
        [U, S, V] = svd(PQ_trans);

        R{i,j} = V * U';
        if (det(R{i,j}) > 0)
            R{i,j} = V * diag([1, -1]) * U';
        end

        t{i,j} = (mean(p))' - R{i,j}*(mean(P,2));

    end

end


%% Plot Link

% Build Robot
links{1} = buildLinkType5();
links{2} = buildLinkType6();
links{3} = buildLinkType7();
links{4} = buildLinkType8();
links{5} = buildLinkType9();
links{6} = buildLinkType10();

robot = BuildRobot(links);


for i = 1:N
    for j = 1:nLinks

            link_shape = R{i,j} * robot.link_shapes{j} * data.to_pixel(i) + t{i,j};

            figure(i)
            hold on
            plot(link_shape(1,:), link_shape(2,:))

    end
end





%% Compute robot configurations

tensions = [1,1; 1,2; 1,3; 2,1; 3,1];


robots = cell(1,N);

for i = 1:N
    
    robots{i} = SolveRJMKin(robot, tensions(i,:));

end


%% Plot Robot Model

for i = 1:N

    for j = 1:nLinks

        % to pixel
        robots{i}.T{j}(1:2, 3) = robots{i}.T{j}(1:2, 3) * data.to_pixel(i);
        robots{i}.link_shapes{j} = robots{i}.link_shapes{j} * data.to_pixel(i);
        robots{i}.links{j}.child_hole_pos = robots{i}.links{j}.child_hole_pos * data.to_pixel(i);
        robots{i}.links{j}.parent_hole_pos = robots{i}.links{j}.parent_hole_pos * data.to_pixel(i);

        % base transformation
        robots{i}.T{j} = [R{i,1}, t{i,1}; 0,0,1] * robots{i}.T{j};
        

    end

    figure(i)
    hold on
    plotRJM(robots{i});


end



















