function layer = buildLinkType1()


layer = struct;
layer.child_zero_angle = 0;
layer.child_zero_pos = [0,2];
layer.child_curv_func = @(s)-(25-s^2)*0.01;
layer.child_surf_limit = [-3, 3];
layer.child_hole_pos = [[-2;1], [2;1]];

layer.parent_zero_angle = 0;
layer.parent_zero_pos = [0,-2];
layer.parent_curv_func = @(s)(25-s^2)*0.01;
layer.parent_surf_limit = [-3, 3];
layer.parent_hole_pos = [[-2;-1], [2;-1]];

end

