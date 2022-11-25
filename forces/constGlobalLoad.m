function [f, df] = constGlobalLoad(T, f_global, p_acting)
% p_acting: body-fixed point where the force is applied

    if (nargin < 3)
        p_acting = [0;0];
    end

    R_trans = T(1:2, 1:2)';

    f = f_global;
    f(2:3) = R_trans * f(2:3);
    
    if nargout > 1
        df = zeros(3);
        df(2:3,1) = R_trans * [f_global(3); -f_global(2)];
        df(1,1) = -[p_acting(2), -p_acting(1)] * df(2:3,1);
    end

end

