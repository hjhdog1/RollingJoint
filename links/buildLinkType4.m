function layer = buildLinkType4(s_min, s_max, curv)

% This layer incorporates flat-curved-flat rolling surface.
% s_min, s_max: rolling surface range with nonzero curvature
% curv: nonzero curvature

if (nargin < 3)
    curv = 0.5;
end


if (nargin < 1)
    s_min = 0.5;
    s_max = 1.5;
end



layer = struct;
layer.child_zero_angle = 0.0;
layer.child_zero_pos = [0,2];
layer.child_curv_func = @(s)rectFunction(s, s_min, s_max, 0, -curv);
layer.child_surf_limit = [-3, 3];
layer.child_hole_pos = [[-2;1], [2;1]];

layer.parent_zero_angle = 0.0;
layer.parent_zero_pos = [0,-2];
layer.parent_curv_func = @(s)rectFunction(s, s_min+0.4, s_max+0.4, 0, curv);
layer.parent_surf_limit = [-3, 3];
layer.parent_hole_pos = [[-2;-1], [2;-1]];


end

