function [] = plotRJM(robot)

    % links
    for i = 1:robot.nLinks
        shape_l = robot.link_shapes{i};
        shape_g = robot.T{i}(1:2,1:2) * shape_l + robot.T{i}(1:2,3);
        
        hold on
        plot(shape_g(1,:), shape_g(2,:)); 
        plot2DFrame(robot.T{i}, 5.0)
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
    end
    
    plot(tendon_l(1,:), tendon_l(2,:), 'go-', 'LineWidth', 2);
    plot(tendon_r(1,:), tendon_r(2,:), 'go-', 'LineWidth', 2);
    
    
end

