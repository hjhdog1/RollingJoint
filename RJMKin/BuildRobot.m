function robot = BuildRobot(links, s0, f0)
    

    % declare robot
    robot = struct;
    
    % set links
    robot.links = links;
    robot.nLinks = length(links);
    
    % set contact surfaces and link shapes
    for i = 1:robot.nLinks
        [sc, Tc, sp, Tp] = getContactSurfaces(links{i}, 100);
        robot.get_Tc_uc{i} = @(s)InterpolateTransform(sc, Tc, s);
        robot.get_Tp_up{i} = @(s)InterpolateTransform(sp, Tp, s);
        
        robot.link_shapes{i} = [reshape(Tc(1:2,3,:),2,[]), reshape(Tp(1:2,3,end:-1:1),2,[])];
        robot.link_shapes{i} = [robot.link_shapes{i}, robot.link_shapes{i}(:,1)];
    end
    
    
    % set initial position
    if nargin < 2
        robot.s = zeros(1, robot.nLinks-1);
        robot.f = zeros(2, robot.nLinks-1);
%         robot.f = ones(2, robot.nLinks-1);
%         robot.f = rand(2, robot.nLinks-1);
    else
        robot.s = s0;
        robot.f = f0;
    end
    
    % initial link transformations
%     [robot.T, robot.Tc, robot.Tp, robot.uc, robot.up] = propagateTransforms(robot);
    robot = propagateTransforms(robot);
        
    
end