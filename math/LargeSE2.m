function T = LargeSE2(w,v)

wsqr = w*w;
wnorm = abs(w);


T = eye(3);
if wnorm > eps
    T(1:2,1:2) = RotZ(w);
    Wv = w*[-v(2); v(1)];
    WWv = -wsqr * v;

    T(1:2,3) = v + (1-cos(wnorm))/wsqr*Wv + (wnorm - sin(wnorm))/(wnorm*wsqr) * WWv;
else
    T = [eye(2) v; zeros(1,2) 1];
end

