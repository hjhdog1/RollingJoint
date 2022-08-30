function y = rectFunction(x, minx, maxx, miny, maxy)

isInRange = (x >= minx) & (x < maxx);

y = isInRange * (maxy - miny) + miny;

end

