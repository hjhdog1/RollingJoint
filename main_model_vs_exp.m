%% Compare Model and Experiments
clc;
clear all;
close all;


%% Read images
imds = imageDatastore(fullfile("imageprocessing","img","Test1","crop_flat"),...
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


%% Build Robot
links{1} = buildLinkType5();
links{2} = buildLinkType6();
links{3} = buildLinkType7();
links{4} = buildLinkType8();
links{5} = buildLinkType9();
links{6} = buildLinkType10();

robot = BuildRobot(links);

% % push holes inside
% robot_ogirinal = robot;
% 
% robot = pushHolesInside(robot, 1.0);
% 
% % Test kinematics
% 
% robot_ogirinal = SolveRJMKin(robot_ogirinal, [1,2]);
% robot = SolveRJMKin(robot, [1,2]);
% 
% % figure(111)
% % hold off
% figure
% plotRJM(robot_ogirinal, [1,0,0]);
% plotRJM(robot, [0,0,1]);
% 
% axis equal

%% Plot Link
% 
for i = 1:N
    for j = 1:nLinks
% for i = 1
%     for j = 2

        link_shape = R{i,j} * robot.link_shapes{j} * data.to_pixel(i) + t{i,j};

        figure(i)
        hold on
        plot(link_shape(1,:), link_shape(2,:))

        % calculate contact points
        if j == nLinks
            continue
        end

        T1 = [R{i,j}, t{i,j} * data.to_mm(i); 0,0,1];
        T2 = [R{i,j+1}, t{i,j+1} * data.to_mm(i); 0,0,1];

        [s1, s2] = getContactPoints(robot.get_Tc_uc{j}, robot.get_Tp_up{j+1}, T1, T2);
        slip(i,j) = s2 - s1;
        disp([num2str(i), '/', num2str(j), ': ', num2str(s1 - s2)]);

        Tc1 = robot.get_Tc_uc{j}(s1);
        Tp2 = robot.get_Tp_up{j+1}(s2);

%         contact1 = R{i,j} * Tc1(1:2,3) * data.to_pixel(i) + t{i,j};
%         contact2 = R{i,j+1} * Tp2(1:2,3) * data.to_pixel(i) + t{i,j+1};

        contact1 = T1 * Tc1(:,3) * data.to_pixel(i);
        contact2 = T2 * Tp2(:,3) * data.to_pixel(i);

        plot(contact1(1), contact1(2), 'ro')
        plot(contact2(1), contact2(2), 'bx')
            

    end
end





% Compute robot configurations

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



















