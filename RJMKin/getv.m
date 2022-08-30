function [v, vhat] = getv(robot, i)

    c = robot.links{i}.child_hole_pos;      % child holes

    Tnext = InvSE2(robot.T{i}) * robot.T{i+1}; % transform to next link
    pnext = robot.links{i+1}.parent_hole_pos;     % parent holes in next link
    v = Tnext(1:2, 1:2) * pnext + Tnext(1:2, 3) - c;
    
    
    normv = [norm(v(:,1)), norm(v(:,2))];
    normv(normv < 1e-12) = 1e-12;
    
    vhat = v ./ normv;

end

