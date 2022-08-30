%% Test Kinematics
clc;
clear all;
close all;


%% Define links
% links{1} = buildLinkType1();
% links{2} = buildLinkType1();
% links{3} = buildLinkType1();
% links{4} = buildLinkType1();
% links{5} = buildLinkType1();
% links{6} = buildLinkType1();
% links{7} = buildLinkType1();
% links{8} = buildLinkType1();
% links{9} = buildLinkType1();
% links{10} = buildLinkType1();
% links{11} = buildLinkType1();
% links{12} = buildLinkType1();
% links{13} = buildLinkType1();
% links{14} = buildLinkType1();
% links{15} = buildLinkType1();


links{1} = buildLinkType1();
links{2} = buildLinkType2();
% links{3} = buildLinkType1();
% links{4} = buildLinkType2();
% links{5} = buildLinkType1();
% links{6} = buildLinkType2();
links{3} = buildLinkType3();
links{4} = buildLinkType1();
links{5} = buildLinkType2();
links{6} = buildLinkType3();
links{7} = buildLinkType4(0.3, 0.7, 0.5);
links{8} = buildLinkType1();
links{9} = buildLinkType2();
links{10} = buildLinkType3();


% links{1} = buildLinkType4(1.5, 1.9, 0.5);
% links{2} = buildLinkType4(1.1, 1.5, 0.5);
% links{3} = buildLinkType4(0.7, 1.1, 0.5);
% links{4} = buildLinkType4(0.3, 0.7, 0.5);


% links{1} = buildLinkType4(1.5, 1.9, 0.5);
% links{2} = buildLinkType4(1.1, 1.5, 0.5);
% links{3} = buildLinkType4(0.7, 1.1, 0.5);
% links{4} = buildLinkType4(0.3, 0.7, 0.5);



% for i = length(links)
%     links{i}.extLoad = @(T)constGlobalLoad(T, [0;0.0;-0.0]);
% end


%% Build Robot
robot = BuildRobot(links);

% %% Kinematics
% % tensions = [2,2];
% tensions = [4,2];
% robot = SolveRJMKin(robot, tensions);
% 
% figure;
% plotRJM(robot);
% axis equal
% 
% % Plot Robot
% figure;
% plotRJM(robot);
% axis equal


%% Animation over configurations
% for t = 0:0.1:100
%     tensions = [2 - sin(t), 2 + sin(t)];
% %     tensions = [1,3];
%     robot = SolveRJMKin(robot, tensions);
%     
%     clf
%     plotRJM(robot);
%     axis equal
%     drawnow
%     
% end

%% Animation over external force
for t = 1:0.5:100
    
    robot.links{end}.extLoad = @(T)constGlobalLoad(T, [0;0.03;-0.03]);
    
    tensions = [t, 1.5*t];
    robot = SolveRJMKin(robot, tensions);
    
    clf
    plotRJM(robot);
    axis equal
    drawnow
    
end


% 
% %% Spead test
% 
% tic;
% robot = BuildRobot(links);
% for i = 1:300
%     
%     robot.s(:) = 0;
%     robot.f(:) = 0;
%     
%     tensions = [4,2];
%     robot = SolveRJMKin(robot, tensions);
%     
% %     i
%     
% end
% toc