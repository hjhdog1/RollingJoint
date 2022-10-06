function [clusters, id_remove] = clusterPoints(points, radius)
% radius: radius of each cluster
% points: N X 2 matrix

N = size(points, 1);

dist_sqr = getDistSqrMat(points);

id_remove = [];
for i = 1:N
    id_cur = i;
    for  j = i+1:N
        
        if (dist_sqr(i,j) <= radius^2)
            id_remove = [id_remove, j];
            id_cur = [id_cur, j];
        end

        if length(id_cur) > 1
             p = points(id_cur,:);
             points(id_cur,:) = ones(length(id_cur),1) * mean(p);
        end 

    end
end

clusters = points;
clusters(id_remove, :) = [];




end