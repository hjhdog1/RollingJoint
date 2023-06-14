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


%% Animation over configurations

% calculate kinematics
tensions = [2,1];
robot = SolveRJMKin(robot, tensions);

% robot shape
clr = ones(1,3) * 0.2;

h_figure = figure;
plotRJM_noFrame(robot, clr);
axis equal

text(-38,0,'Fixed base', 'FontSize', 12)


% tensions
for i = 1:2
    p = robot.links{1}.parent_hole_pos(:,i)';
    tipP = p - [0, tensions(i)] * 8 - [0, 2];

%     clr = [0,1,0];

    drawArrowTip(tipP, -0.5*pi, 4, clr, 1)
    plot([p(1), tipP(1)], [p(2)+1, tipP(2)+1], 'Color', clr, 'LineWidth', 2);
    plot(p(1), p(2), 'o', 'MarkerSize', 2, 'Color', clr, 'LineWidth', 2);

end

text(-6,-22,'Input tensions', 'FontSize', 12)


% figure setting
set(h_figure,'Position',[100,100,350,370])

set(gca,'Visible','off')

set(gca,'LooseInset',get(gca,'TightInset'))
axis equal

set(gca, 'XLim', gca().XLim + [-1, 1], 'YLim', gca().YLim + [-1, 1])
set(gca,'LooseInset',get(gca,'TightInset'))

