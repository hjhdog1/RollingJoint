function [s1, s2] = getContactPoints(link1_get_Tc_uc, link2_get_Tp_up, T1, T2)


    T1 = double(T1);
    T2 = double(T2);


    % parent contact surface curve of link2
    N = 500;
    
    s2_array = linspace (-15, 15, N);

    pcurve2 = zeros(3, N);
    for i = 1:N
        Tp2 = link2_get_Tp_up(s2_array(i));
        pcurve2(:,i) = Tp2(:,3);
    end
    pcurve2 = T2 * pcurve2;

    f = @(s1)-penetrationDepth(T1 * link1_get_Tc_uc(s1), pcurve2);

    s1 = fminunc(f, 0);

    [~, id2, frac2] = penetrationDepth(T1 * link1_get_Tc_uc(s1), pcurve2);
    s2 = (1-frac2) * s2_array(id2) + frac2 * s2_array(id2+1);


end