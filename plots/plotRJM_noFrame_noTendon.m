function [] = plotRJM_noFrame_noTendon(robot, clr, line_style)

    if nargin < 3
        line_style = '-';
    end

    % links
    for i = 1:robot.nLinks
        shape_l = robot.link_shapes{i};
        shape_g = robot.T{i}(1:2,1:2) * shape_l + robot.T{i}(1:2,3);
        
        hold on
        if nargin > 1
            plot(shape_g(1,:), shape_g(2,:), line_style, 'Color', clr); 
        else
            plot(shape_g(1,:), shape_g(2,:)); 
        end
    end
    
    
end

