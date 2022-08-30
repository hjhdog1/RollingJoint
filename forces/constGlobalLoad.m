function [f, df] = constGlobalLoad(T, f_global)

    R_trans = T(1:2, 1:2)';

    f = f_global;
    f(2:3) = R_trans * f(2:3);
    
    if nargout > 1
        df = zeros(3);
        df(2:3,1) = R_trans * [f_global(3); -f_global(2)];
    end

end

