function h = plot2DFrame(T, size)

if nargin < 2
    size = 1;
end

c = T(1:2,3);
x = T(1:2,1);
y = T(1:2,2);

p = [c + size*x, c, c+size*y];

h = plot(p(1,:), p(2,:), 'k');



end

