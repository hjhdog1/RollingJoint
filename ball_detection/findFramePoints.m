function [id_center, frame_points_id] = findFramePoints(points, axis_length)
% points: N X 2 matrix
% axis_length: distance between balls

% Find sets of 3 points perpendicularly aligned with given axis_length.
% +-15% magin of axis_length is applied.

delta = 0.1;

N = size(points, 1);

dist_sqr = getDistSqrMat(points);

id_center = [];
for i = 1:N
    frame_points_id{i} = i;
    for  j = 1:N
        
        if (dist_sqr(i,j) <= ((1.0+delta) * axis_length)^2 &&  dist_sqr(i,j) >= ((1.0-delta) * axis_length)^2)
            frame_points_id{i} = [frame_points_id{i}, j];
        end
    end

    if (length(frame_points_id{i}) == 3)
        p = points(frame_points_id{i},:);
        d = norm(p(2,:) - p(3,:));
        if (d <= (1.0+delta) * sqrt(2) * axis_length && d >= (1.0-delta) * sqrt(2) * axis_length)
            id_center = [id_center, i];
        end

%         p = points(frame_points_id{i},:);
%         dp21 = (p(2,:) - p(1,:));
%         dp31 = (p(3,:) - p(1,:));
%         dp21 = dp21/norm(dp21);
%         dp31 = dp31/norm(dp31);
% 
%         c = dp21*dp31';
% 
%         if abs(c) <= delta
%             id_center = [id_center, i];
%         end
    end
end

frame_points_id = frame_points_id(id_center);


end