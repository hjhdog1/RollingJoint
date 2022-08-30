function [w, what] = getw(robot, i)
    
    p = robot.links{i}.parent_hole_pos;      % parent holes
    
    Tprev = InvSE2(robot.T{i}) * robot.T{i-1}; % transform to prev. link
    cprev = robot.links{i-1}.child_hole_pos;     % child holes in prev. link        
    w = Tprev(1:2, 1:2) * cprev + Tprev(1:2, 3) - p;
    
    
    normw = [norm(w(:,1)), norm(w(:,2))];
    normw(normw < 1e-12) = 1e-12;
    
    what = w ./ normw;

end

