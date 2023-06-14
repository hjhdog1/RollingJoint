function layer = buildLinkType1()


layer = struct;
layer.child_zero_angle = 0;
layer.child_zero_pos = [0,10];
layer.child_curv_func = @(s)-(25-(s/5)^2)*0.002;
layer.child_surf_limit = [-15, 15];
layer.child_hole_pos = [[-10;5], [10;5]];

layer.parent_zero_angle = 0;
layer.parent_zero_pos = [0,-10];
layer.parent_curv_func = @(s)(25-(s/5)^2)*0.002;
layer.parent_surf_limit = [-15, 15];
layer.parent_hole_pos = [[-10;-5], [10;-5]];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [sc, Tc, sp, Tp] = getContactSurfaces(layer, 100);
    get_Tc_uc = @(s)InterpolateTransform(sc, Tc, s);
    get_Tp_up = @(s)InterpolateTransform(sp, Tp, s);

    Tc_l = get_Tc_uc(-10);
    Tc_r = get_Tc_uc(10);
    
    Tp_l = get_Tp_up(-10);
    Tp_r = get_Tp_up(10);
    
    layer.child_hole_pos = [Tc_l(1:2,3), Tc_r(1:2,3)]; 
    layer.parent_hole_pos = [Tp_l(1:2,3), Tp_r(1:2,3)]; 
    
end

