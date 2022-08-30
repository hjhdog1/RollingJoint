function W = so2(w)

    if prod(size(w) == [1,1])
        W = [0, -w; w, 0];
    else
        W = [w(2); -w(1)];
    end

end

