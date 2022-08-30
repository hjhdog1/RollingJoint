function robot = SolveRJMKin(robot, tensions)
% robot: robot struct
% T: output transformations of links

    % init forces
%     robot.f(2,:) = sum(tensions);

    % numerical parameters
    stepsize = 1.0;

    % looping
    for i = 1:10
        
        % link transformations and load errors
        robot = propagateTransforms(robot);
        err = propagateLoadErrors(robot, tensions);
        
        % calculate updates
        [ds, df] = getUpdates(robot, err, tensions);
        
        % update robot
        robot.s = robot.s - stepsize*ds;
        robot.f = robot.f - stepsize*df;
        
        % limit s
        for j = 1:robot.nLinks-1
            robot.s(j) = max(robot.s(j), robot.links{j}.child_surf_limit(1) + 1e-12);
            robot.s(j) = min(robot.s(j), robot.links{j}.child_surf_limit(2) - 1e-12);
        end
        
        % print
%         norm(err{3})
        
    end
    
    cell2mat(err)
    
    % final link transformations
    robot = propagateTransforms(robot);

end