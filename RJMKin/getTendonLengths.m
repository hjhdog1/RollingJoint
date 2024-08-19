function tendon_lengths = getTendonLengths(robot)
% robot: robot struct
% tendon_lengths: tendon lengths at current robot configuration


    % tendon_lengths = zeros(1,2);
    tendon_lengths = vecnorm(robot.links{1}.child_hole_pos - robot.links{1}.parent_hole_pos);
    for i = 2:robot.nLinks
        a = robot.T{i-1}*[robot.links{i-1}.child_hole_pos; 1,1];
        b = robot.T{i}*[robot.links{i}.parent_hole_pos; 1,1];

        % between links
        tendon_lengths = tendon_lengths + vecnorm(a-b);

        % withdin link i
        tendon_lengths = tendon_lengths + vecnorm(robot.links{i}.child_hole_pos - robot.links{i}.parent_hole_pos);
    end


end