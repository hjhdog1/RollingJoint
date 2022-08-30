function layer = buildLinkType2()

d = 0.7;

layer = struct;
layer.child_zero_angle = 0.3;
layer.child_zero_pos = [0,2];
layer.child_curv_func = @(s)-(25-s^2 + s)*0.01;
layer.child_surf_limit = [-3, 3];
layer.child_hole_pos = [[-2;0.8-d], [2;0.8+d]];

layer.parent_zero_angle = 0.3;
layer.parent_zero_pos = [0,-2];
layer.parent_curv_func = @(s)(25-s^2 - s)*0.01;
layer.parent_surf_limit = [-3, 3];
layer.parent_hole_pos = [[-2;-0.8-d], [2;-0.8+d]];


end

