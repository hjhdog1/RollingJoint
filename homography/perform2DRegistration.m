function [R, t, scale, reporjection] = perform2DRegistration(targetPoints, modelPoints)
% performing 2D point-to-point regisitraiotn
% allowing rotation, translation, and scaling


% align input points as column vectors
if size(targetPoints, 1) ~= 2
    targetPoints = targetPoints';
end

if size(modelPoints, 1) ~= 2
    modelPoints = modelPoints';
end

% Calculate R, t, scale
p_mean = mean(modelPoints,2);
q_mean = mean(targetPoints,2);

P = modelPoints - p_mean;
Q = targetPoints - q_mean;


[U, ~, V] = svd(P * Q');
R = V * U';
if det(R) < 0
    R = V * diag([1, -1]) * U';
end

scale = trace(P*Q'*R) / trace(P*P');

t = q_mean - scale * R * p_mean;

% Calculate reprojection
reporjection = scale * R * modelPoints + t;


end

