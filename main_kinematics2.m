%% Test Kinematics
clc;
clear all;
% close all;


%% Define links
links{1} = buildLinkType5();
links{2} = buildLinkType6();
links{4} = buildLinkType7();
links{3} = buildLinkType8();
links{5} = buildLinkType9();
links{6} = buildLinkType10();



%% Build Robot
robot = BuildRobot(links);


%% Animation over configurations
figure

tensions = [1,3];
robot = SolveRJMKin(robot, tensions);

plotRJM(robot);
axis equal

% 
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
% 
% for t = 0
%     tensions = [3, 1];
% %     tensions = [1,3];
%     robot = SolveRJMKin(robot, tensions);
%     
%     clf
%     plotRJM(robot);
%     axis equal
%     drawnow
%     
% end

% % Animation over external force
% for t = 1:0.1:100
%     
%     robot.links{end}.extLoad = @(T)constGlobalLoad(T, [0;0.05;0]);
%     
%     tensions = [t, 1.5*t];
%     robot = SolveRJMKin(robot, tensions);
%     
%     clf
%     plotRJM(robot);
%     axis equal
%     drawnow
%     
% end


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