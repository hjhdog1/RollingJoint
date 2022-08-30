function robot = propagateTransforms(robot)

%     T = zeros(3,3,robot.nLinks);
%     Tc = zeros(3,3,robot.nLinks);
%     Tp = zeros(3,3,robot.nLinks);
%     
%     T(:,:,1) = eye(3);
%     for i = 2:robot.nLinks
%         Tc(:,:,i-1) = robot.get_Tc_uc{i-1}(robot.s(i-1));
%         Tp(:,:,i) = robot.get_Tp_up{i}(robot.s(i-1));
%         T(:,:,i) = T(:,:,i-1) * Tc(:,:,i-1) * InvSE2(Tp(:,:,i));
%     end

    T = cell(1,robot.nLinks);
    Tc = cell(1,robot.nLinks);
    Tp = cell(1,robot.nLinks);
    
    uc = nan(1,robot.nLinks);
    up = nan(1,robot.nLinks);
    
    T{1} = eye(3);
    for i = 2:robot.nLinks
        [Tc{i-1}, uc(i-1)] = robot.get_Tc_uc{i-1}(robot.s(i-1));
        [Tp{i}, up(i)] = robot.get_Tp_up{i}(robot.s(i-1));
        T{i} = T{i-1} * Tc{i-1} * InvSE2(Tp{i});
    end
    
    % substitute into robot
    robot.T = T;
    robot.Tc = Tc;
    robot.Tp = Tp;
    robot.uc = uc;
    robot.up = up;


end

