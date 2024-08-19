%% Test Kinematics
clc;
clear all;
close all;


%% Define links
links{1} = buildLinkType1();
links{2} = buildLinkType2();
links{3} = buildLinkType3();
links{4} = buildLinkType4();
links{5} = buildLinkType5();


%% Build Robot
robot = BuildRobot(links);


%% Init Robot configuration
tensions0 = [1, 3];
robot0 = SolveRJMKin(robot, tensions0);

tendon_lengths = getTendonLengths(robot0);


%% Animate robot configuration
for t = 0:0.1:100
    displacements = tendon_lengths + 10*[sin(t),-sin(t)];
    robot = SolveRJMKin_disp(robot0, displacements, tensions0);
    
    clf;
    plotRJM(robot);
    axis equal
    drawnow
    
end

% 
% %% Displacement Actuation
% 
% displacements = tendon_lengths + [-10,10];
% tensions0 = tensions;
% 
% robot = SolveRJMKin_disp(robot, displacements, tensions0);
% 
% displacements_actual = getTendonLengths(robot);
% displacements_actual - displacements
% 
% 
% figure
% plotRJM(robot);
% axis equal
% drawnow