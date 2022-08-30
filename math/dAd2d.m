function ret = dAd2d(T)

    R = T(1:2, 1:2);
    p = T(1:2,3);
    
%     ret = [1, -so2(p)'*R; [0;0], R];
    ret = [1, [-p(2), p(1)]*R; [0;0], R];

end

