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

force_array = linspace(0,1.5,4);
n = length(force_array);

legend_array = cell(1,n);

clrs = lines(n);

h_figure = figure;
for i = 1:n

    f = force_array(i);
    robot.links{end}.extLoad = @(T)constGlobalLoad(T, [0;f;0], [0.0, 0.0]);
 
    tensions = [6, 3];
    robot = SolveRJMKin(robot, tensions);
    
    h_plots(i) = plotRJM_noFrame(robot, clrs(i,:));

    
    % plot forces
    if i > 1
        tipP = robot.T{end}(1:2,3)';
        drawArrowTip(tipP + [8*(i-1), 0], 0.0, 4, clrs(i,:), 1)
        plot([tipP(1), tipP(1) + 8*(i-1)-1], [tipP(2), tipP(2)], 'Color', clrs(i,:), 'LineWidth', 2);
        plot(tipP(1), tipP(2), 'o', 'MarkerSize', 2, 'Color', clrs(i,:), 'LineWidth', 2);
    end

    % legends
    legend_array{i} = ['force = ', num2str(f)];
end
axis equal
grid on

text(17,0,'Base', 'FontSize', 12)


set(h_figure,'Position',[100,100,450,350])
set(gca,'LooseInset',get(gca,'TightInset'))
axis equal

set(gca, 'XLim', gca().XLim + [-5, 5], 'YLim', gca().YLim + [-5, 5])
set(gca,'LooseInset',get(gca,'TightInset'))


legend(h_plots, legend_array, 'Interpreter','latex', 'FontSize', 12, 'Location', 'SouthWest');