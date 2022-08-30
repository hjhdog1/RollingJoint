function err = propagateLoadErrors(robot, tensions)


    err = cell(1, robot.nLinks);
    
    for i = 2:robot.nLinks
        
        % init. error
        err{i} = zeros(3,1);
        
        % tendon holes
        c = robot.links{i}.child_hole_pos;      % child holes
        p = robot.links{i}.parent_hole_pos;      % parent holes
        
        if i < robot.nLinks
            % forces associated with next link
            [~, vhat] = getv(robot, i);
%             vhat = v ./ ([norm(v(:,1)), norm(v(:,2))] + 1e-12);

            for j = 1:2     % loop over (left, right)
                T_cur = [eye(2), c(:,j); 0,0,1];
                err{i} = err{i} + dAd2d(T_cur) * [0; tensions(j)*vhat(:,j)];
            end

            err{i} = err{i} - dAd2d(robot.Tc{i}) * [0; robot.f(:,i)];
        end
        
        
        % forces associated with prev. link
%         w = getw(robot, i);
        [~, what] = getw(robot, i);
%         what = w ./ ([norm(w(:,1)), norm(w(:,2))] + 1e-12);
        
        for j = 1:2     % loop over (left, right)
            T_cur = [eye(2), p(:,j); 0,0,1];
            err{i} = err{i} + dAd2d(T_cur) * [0; tensions(j)*what(:,j)];
        end
        
        err{i} = err{i} + dAd2d(robot.Tp{i}) * [0; robot.f(:,i-1)];
        
        
        % external load
        if isfield(robot.links{i}, 'extLoad')
            f_ext = robot.links{i}.extLoad(robot.T{i});
        else
            f_ext = zeros(3,1);
        end
        
        err{i} = err{i} + f_ext;
        
    end

    

end

