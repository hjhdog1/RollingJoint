function h = plotRJM_noFrame(robot, clr, line_style)

    if nargin < 3
        line_style = '-';
    end

    % links
    for i = 1:robot.nLinks
        shape_l = robot.link_shapes{i};
        shape_g = robot.T{i}(1:2,1:2) * shape_l + robot.T{i}(1:2,3);
        
        hold on
        if nargin > 1
            h = plot(shape_g(1,:), shape_g(2,:), line_style, 'Color', clr); 
        else
            h = plot(shape_g(1,:), shape_g(2,:)); 
        end
    end
        
    % tendions
    tendon_l = zeros(2, robot.nLinks*2);
    tendon_r = zeros(2, robot.nLinks*2);

    for i = 1:robot.nLinks
        
        holes_c = robot.T{i}(1:2,1:2) * robot.links{i}.child_hole_pos + robot.T{i}(1:2,3);
        holes_p = robot.T{i}(1:2,1:2) * robot.links{i}.parent_hole_pos + robot.T{i}(1:2,3);

        tendon_l(:, 2*i-1) = holes_p(:,1);
        tendon_r(:, 2*i-1) = holes_p(:,2);        
        
        tendon_l(:, 2*i) = holes_c(:,1);
        tendon_r(:, 2*i) = holes_c(:,2);



        if nargin > 1
            if i > 1
                plot(tendon_l(1,2*i-2:2*i-1), tendon_l(2,2*i-2:2*i-1), line_style, 'Color', clr, 'LineWidth', 1);
                plot(tendon_r(1,2*i-2:2*i-1), tendon_r(2,2*i-2:2*i-1), line_style, 'Color', clr, 'LineWidth', 1);
            end
            plot(tendon_l(1,2*i-1:2*i), tendon_l(2,2*i-1:2*i), '--', 'Color', clr, 'LineWidth', 1);
            plot(tendon_r(1,2*i-1:2*i), tendon_r(2,2*i-1:2*i), '--', 'Color', clr, 'LineWidth', 1);
        else
            if i > 1
                plot(tendon_l(1,2*i-2:2*i-1), tendon_l(2,2*i-2:2*i-1), 'go-', 'LineWidth', 1);
                plot(tendon_r(1,2*i-2:2*i-1), tendon_r(2,2*i-2:2*i-1), 'go-', 'LineWidth', 1);
            end
            plot(tendon_l(1,2*i-1:2*i), tendon_l(2,2*i-1:2*i), 'go--', 'LineWidth', 1);
            plot(tendon_r(1,2*i-1:2*i), tendon_r(2,2*i-1:2*i), 'go--', 'LineWidth', 1);
        end

    end
    
end

