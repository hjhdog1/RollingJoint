function score = calculateCrossCorrelation(img_mean_removed, center, radius)
% Calculating cross correlation

% img_mean_removed: grayscale image of ball subtracted by its mean
% center0: initial guess of center
% radius: ball radius

cx = center(1);
cy = center(2);

[ny, nx] = size(img_mean_removed);

sig = radius;

% create mask
mask1 = zeros(ny, nx);
for i = 1:ny
    for j = 1:nx
        mask1(i,j) = -exp(-((i-cy)^2 + (j-cx)^2)/sig^2);
    end
end
mask1 = mask1 - mean(mask1(:));
mask1 = mask1 / norm(mask1(:));

% calculate cross correlation
score = sum(sum(img_mean_removed .* mask1));


% % plot
% hold off
% img_plot = zeros(ny, nx, 3);
% img_plot(:,:,1) = img_mean_removed - min(img_mean_removed(:));
% img_plot(:,:,2) = -(mask1 - max(mask1(:)));
% 
% imshow(img_plot);


end