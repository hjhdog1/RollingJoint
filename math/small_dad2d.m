function ret = small_dad2d(w,v)


%     ret = [0, -so2(v)'; zeros(2,1), so2(w)];
%     ret = [0, -v(2), v(1); zeros(2,1), [0, -w; w, 0]];    
    ret = [0, -v(2), v(1); 0, 0, -w; 0, w, 0];

end

