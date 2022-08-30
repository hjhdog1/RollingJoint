function dvhat_ds = getdvhatds(robot, i)

    c = robot.links{i}.child_hole_pos;      % child holes

    Tnext = InvSE2(robot.T{i}) * robot.T{i+1}; % transform to next link
    pnext = robot.links{i+1}.parent_hole_pos;     % parent holes in next link
    v = Tnext(1:2, 1:2) * pnext + Tnext(1:2, 3) - c;
    
    
    normv = [norm(v(:,1)), norm(v(:,2))];
    normv(normv < 1e-12) = 1e-12;
    
    vhat = v ./ normv;
    
    
    % differentiation
    Rnext = Tnext(1:2,1:2);
    tpnext = robot.Tp{i+1}(1:2,3);
    
    dvhat_ds = zeros(2);
    for j = 1:2
        N = eye(2) - vhat(:,j) * vhat(:,j)';
%         dvhat_ds(:,j) = (N * so2(robot.uc(i) - robot.up(i+1)) * Rnext * (pnext(:,j) - tpnext)) / normv(j);

        temp = Rnext * (pnext(:,j) - tpnext) / normv(j);
        dvhat_ds(:,j) = N * ((robot.uc(i) - robot.up(i+1)) * [-temp(2); temp(1)]);
    end

end

