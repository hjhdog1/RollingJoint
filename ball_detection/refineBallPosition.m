function center = refineBallPosition(img, center0, radius)
% Maximizing cross correlation to find ball center

% img: image of ball (n X m grayscale matrix)
% center0: initial guess of center
% radius: ball radius


% remove mean of image
img_mean_removed = img - mean(img(:));

% define objective funciton
% radius = 3;
f = @(center)-calculateCrossCorrelation(img_mean_removed, center, radius);


% solve optimization
[ny, nx] = size(img_mean_removed);

% center0 = 0.5*[nx, ny];
center = fminunc(f, center0);


end