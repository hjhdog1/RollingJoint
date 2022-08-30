function [ds, df, A,B,C,D,E] = getUpdates(robot, err, tensions)

%     % TODO: Implement
%     ds = zeros(1,robot.nLinks-1);
%     df = zeros(2,robot.nLinks-1);
    
    
    % declare matrices
    A = cell(1, robot.nLinks);
    B = cell(1, robot.nLinks);
    C = cell(1, robot.nLinks);
    D = cell(1, robot.nLinks);
    E = cell(1, robot.nLinks);
    
    P = cell(1, robot.nLinks);
    Q = cell(1, robot.nLinks);
    
    % calculate matrices
    for i = 2:robot.nLinks
        
        % A to C
        A{i} = -Ad2d(InvSE2(robot.T{i}) * robot.T{i-1});
        temp = -InvSE2(robot.T{i}) * robot.T{i-1};
        B{i} = -[Ad2d(robot.Tp{i}) * [robot.uc(i-1) - robot.up(i); 0; 0], zeros(3,2)];
        
%         C{i} = zeros(3);        % TODO: external load
                
        % external load
        if isfield(robot.links{i}, 'extLoad')            
            [~, C{i}] = robot.links{i}.extLoad(robot.T{i});
        else
            C{i} = zeros(3);
        end
        
        
        % D and E
        c = robot.links{i}.child_hole_pos;      % child holes
        p = robot.links{i}.parent_hole_pos;      % parent holes
        
        if i < robot.nLinks
            
            dvhat_ds = getdvhatds(robot, i);            
            Ds = zeros(3,1);
            for j = 1:2
                Ds = Ds + dAd2d([eye(2), c(:,j); 0,0,1]) * [0; tensions(j) * dvhat_ds(:,j)];
            end
            Ds = Ds - dAd2d(robot.Tc{i}) * small_dad2d(robot.uc(i), [1;0]) * [0; robot.f(:,i)];
            Df = -dAd2d(robot.Tc{i}) * [0, 0; 1, 0; 0, 1];

            D{i} = [Ds, Df];
        else
            D{i} = eye(3);
        end
                
        
        dwhat_ds = getdwhatds(robot, i);
        Es = zeros(3,1);
        for j = 1:2
            Es = Es + dAd2d([eye(2), p(:,j); 0,0,1]) * [0; tensions(j) * dwhat_ds(:,j)];
        end
        Es = Es + dAd2d(robot.Tp{i}) * small_dad2d(robot.up(i), [1;0]) * [0; robot.f(:,i-1)];
        Ef = dAd2d(robot.Tp{i}) * [0, 0; 1, 0; 0, 1];

        E{i} = [Es, Ef];
        
        % P and Q
        Q{i} = inv([eye(3), zeros(3); C{i}, D{i}]);
        P{i} = -Q{i} * [A{i}, B{i}; zeros(3), E{i}];
        
    end
    
    
    % calculate derr and PP
    PP = eye(6);
    de = zeros(6,1);
    for i = 2:robot.nLinks
        PP = P{i} * PP;
        de = P{i} * de;
        de = de + Q{i} * [0;0;0; err{i}];
    end
    
    PPP = [[eye(3); zeros(3)], -PP(:,4:6)];
    
    y = PPP\de;
    
    % calculate dx
    dx = nan(6, robot.nLinks);
    dx(:,1) = [0;0;0; y(4:6)];
    for i = 2:robot.nLinks
        dx(:,i) = P{i} * dx(:,i-1) + Q{i} * [0;0;0; err{i}];        
    end
    
    % return ds and df
    ds = dx(4, 1:end-1);
    df = dx(5:6, 1:end-1);


    
%     % calculate derr and PP - reduced version
%     PP = eye(3);
%     de = zeros(3,1);
%     for i = 2:robot.nLinks
%         Q{i} = inv(D{i});
%         P{i} = -Q{i} * E{i};
%         
%         PP = P{i} * PP;
%         de = P{i} * de;
%         de = de + Q{i} * err{i};
%     end
%     
%     dx1 = -PP\de;
%     
%     % calculate dx
%     dx = nan(3, robot.nLinks);
%     dx(:,1) = dx1;
%     for i = 2:robot.nLinks
%         dx(:,i) = P{i} * dx(:,i-1) + Q{i} * err{i};
%     end
%     
%     % return ds and df
%     ds = dx(1, 1:end-1);
%     df = dx(2:3, 1:end-1);
%     
    

end






























