function dwhat_ds = getdwhatds(robot, i)
    
    p = robot.links{i}.parent_hole_pos;      % parent holes
    
    Tprev = InvSE2(robot.T{i}) * robot.T{i-1}; % transform to prev. link
    cprev = robot.links{i-1}.child_hole_pos;     % child holes in prev. link        
    w = Tprev(1:2, 1:2) * cprev + Tprev(1:2, 3) - p;
    
    
    normw = [norm(w(:,1)), norm(w(:,2))];
    normw(normw < 1e-12) = 1e-12;
    
    what = w ./ normw;
    
    
    % differentiation
    Rprev = Tprev(1:2,1:2);
    tcprev = robot.Tc{i-1}(1:2,3);
    
    dwhat_ds = zeros(2);
    for j = 1:2
        N = eye(2) - what(:,j) * what(:,j)';
%         dwhat_ds(:,j) = (N * so2(robot.up(i) - robot.uc(i-1)) * Rprev * (cprev(:,j) - tcprev)) / normw(j);

        temp = Rprev * (cprev(:,j) - tcprev) / normw(j);
        dwhat_ds(:,j) = N * ((robot.up(i) - robot.uc(i-1)) * [-temp(2); temp(1)]);
    end

end




