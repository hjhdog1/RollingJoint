function [d, id2, frac2] = penetrationDepth(Tc1, pcurve2)

    y = InvSE2(Tc1) * pcurve2;


    id2 = find(y(1,:) > 0, 1) - 1;
    frac2 = -y(1, id2) / (y(1, id2+1) - y(1, id2));

    p = (1-frac2)*y(:, id2) + frac2*y(:, id2+1);
    
    d = -p(2);

end