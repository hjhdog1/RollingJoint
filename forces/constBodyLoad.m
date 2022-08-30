function [f, df] = constBodyLoad(T, f_body)

    f = f_body;
    
    
    if nargout > 1
        df = zeros(3);
    end

end

