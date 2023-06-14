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


%% Animate robot configuration
for t = 0:0.1:100
    tensions = [2 - sin(t), 2 + sin(t)];
    robot = SolveRJMKin(robot, tensions);
    
    clf;
    plotRJM(robot);
    axis equal
    drawnow
    
end
