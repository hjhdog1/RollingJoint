%% Extract link shape
clc;
clear all;
close all;


%% Define links
links{1} = buildLinkType5();
links{2} = buildLinkType6();
links{3} = buildLinkType7();
links{4} = buildLinkType8();
links{5} = buildLinkType9();
links{6} = buildLinkType10();


%% Build robot
robot = BuildRobot(links);

%% Get link shape
i = 1;
c = links{i}.child_hole_pos';
p = links{i}.parent_hole_pos';

shape = robot.link_shapes{i};
curve_c = shape(:, 1:199)';
curve_p = shape(:, 398:-1:200)';

%% Plot
figure
hold on
plot(shape(1,:), shape(2,:));
plot(curve_c(:,1), curve_c(:,2));
plot(curve_p(:,1), curve_p(:,2));

for j = 1:2
    plot([c(j,1), p(j,1)], [c(j,2), p(j,2)], 'go-', 'LineWidth', 2);
end

axis equal
grid on
