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


%% Solve Kinematics & Plot

robot.links{end}.extLoad = @(T)constGlobalLoad(T, [0;0;0], [0.0, 0.0]);

tensions_array = {[3,1], [1,1], [1,3]};     % For Fig. 3(a)
% tensions_array = {[6,2], [2,2], [2,6]};     % For Fig. 3(b)

 n = length(tensions_array);

legend_array = cell(1,n);

clrs = lines(n);

h_figure = figure;
for i = 1:n

    tensions = tensions_array{i};
    robot = SolveRJMKin(robot, tensions);
    
    h_plots(i) = plotRJM_noFrame(robot, clrs(i,:));

    legend_array{i} = ['$(\tau_l, \tau_r)$ = (', num2str(tensions(1)), ', ' , num2str(tensions(2)), ')'];
end
axis equal
grid on

text(16,0,'Base', 'FontSize', 12)
    
set(h_figure,'Position',[100,100,350,400])
set(gca,'LooseInset',get(gca,'TightInset'))
axis equal

set(gca, 'XLim', gca().XLim + [-5, 5], 'YLim', gca().YLim + [-5, 0])
set(gca,'LooseInset',get(gca,'TightInset'))


legend(h_plots, legend_array, 'Interpreter','latex', 'FontSize', 12, 'Location', 'SouthWest');
