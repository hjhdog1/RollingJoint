function robot = pushHolesInside(robot, displacement)
    

    % move hole positions
    for i = 1:robot.nLinks
        c = robot.links{i}.child_hole_pos;
        p = robot.links{i}.parent_hole_pos;

        v = c - p;
        v(:,1) = v(:,1)/norm(v(:,1));
        v(:,2) = v(:,2)/norm(v(:,2));

        robot.links{i}.child_hole_pos = c - displacement * v;
        robot.links{i}.parent_hole_pos = p + displacement * v;
    end
    
    
end