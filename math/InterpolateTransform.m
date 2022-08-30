function [T, u] = InterpolateTransform(s_array, T_array, s_input)

% s_array: array of arclength points
% T_array: array of SE(2) transformations
% s_input: query point

% position = interp1(s_array, 1:length(s_array), s_input);
% i = floor(position);
% frac = position - i;

N = length(s_array);
n = log(N)/log(2);
l = 1;
u = N;
for i = 1:ceil(n+1)
    mid = round(0.5 * (l+u));
    if s_input < s_array(mid)
        u = mid;
    else
        l = mid;
    end
    
    if u-l == 1
        break;
    end
end
i = l;
frac = (s_input - s_array(i)) / (s_array(i+1) - s_array(i));


T1 = T_array(:,:,i);
T2 = T_array(:,:,i+1);


R12 = T1(1:2,1:2)' * T2(1:2,1:2);
dw = LogSO2(R12);

R = T1(1:2,1:2) * RotZ(frac * dw);
p = T1(1:2,3) * (1-frac) + T2(1:2,3) * frac;

T = [R, p; 0,0,1];

if nargout > 1
    ds = s_array(i+1) - s_array(i);
    u = dw/ds;
end


end

