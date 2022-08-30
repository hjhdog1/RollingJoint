function [sc, Tc, sp, Tp] = getContactSurfaces(layer, numStep)

    % check inputs
    if nargin < 2
        numStep = 200;
    end

    % declare required variables
    lim_c = layer.child_surf_limit;
    lim_p = layer.parent_surf_limit;
    
    curv_c = layer.child_curv_func;
    curv_p = layer.parent_curv_func;
    

    % child contact curve
    Tc1 = zeros(3,3,numStep);
    Tc2 = zeros(3,3,numStep);
    
    Tc1(:,:,1) = [RotZ(layer.child_zero_angle), layer.child_zero_pos'; 0,0,1];
    Tc2(:,:,1) = Tc1(:,:,1);
    
    s1 = linspace(0, lim_c(1), numStep);
    s2 = linspace(0, lim_c(2), numStep);
    
    ds1 = s1(2) - s1(1);
    ds2 = s2(2) - s2(1);
    
    for i = 1:numStep-1
        
        u1 = curv_c(s1(i));
        u2 = curv_c(s2(i));
        
        Tc1(:,:,i+1) = Tc1(:,:,i) * LargeSE2(u1 * ds1, [ds1;0]);
        Tc2(:,:,i+1) = Tc2(:,:,i) * LargeSE2(u2 * ds2, [ds2;0]);
    end

    sc = [s1(end:-1:2), s2];
    Tc = cat(3, Tc1(:,:,end:-1:2), Tc2);
    
    
    % parent contacct curve
    Tp1 = zeros(3,3,numStep);
    Tp2 = zeros(3,3,numStep);
    
    Tp1(:,:,1) = [RotZ(layer.parent_zero_angle), layer.parent_zero_pos'; 0,0,1];
    Tp2(:,:,1) = Tp1(:,:,1);
                
    s1 = linspace(0, lim_p(1), numStep);
    s2 = linspace(0, lim_p(2), numStep);
    
    ds1 = s1(2) - s1(1);
    ds2 = s2(2) - s2(1);
    
    for i = 1:numStep-1
        
        u1 = curv_p(s1(i));
        u2 = curv_p(s2(i));
        
%         Tp1(:,:,i+1) = Tp1(:,:,i) * [RotZ(u1 * ds1), [ds1;0]; 0, 0, 1];
%         Tp2(:,:,i+1) = Tp2(:,:,i) * [RotZ(u2 * ds2), [ds2;0]; 0, 0, 1];        
        Tp1(:,:,i+1) = Tp1(:,:,i) * LargeSE2(u1 * ds1, [ds1;0]);
        Tp2(:,:,i+1) = Tp2(:,:,i) * LargeSE2(u2 * ds2, [ds2;0]);
    end
    
    sp = [s1(end:-1:2), s2];
    Tp = cat(3, Tp1(:,:,end:-1:2), Tp2);

end
