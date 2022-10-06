function dist_sqr = getDistSqrMat(points)
% points: N X 2 matrix

dX = points(:,1) - points(:,1)';
dY = points(:,2) - points(:,2)';

dist_sqr = dX.^2 + dY.^2;



end