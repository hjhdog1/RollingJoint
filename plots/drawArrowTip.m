function drawArrowTip(tipP, angle, size, color, width)
% tip: [x,y] = 2D position of pointing conner
% angle: direction of arrow (radian)
% size: width of arrow
% collor: collor of fill

%% Initializing inputs
tipP = reshape(tipP,2,1);

if nargin < 3
    size = 1;
end

if nargin < 4
    color = zeros(1,3);
end

if nargin < 5
    width = 1;
end

%% compute points on arrow tip
pointArray = [-1,-1,0,-1;
              [-0.5,0.5,0,-0.5]*width];
c = cos(angle);
s = sin(angle);
R = [c,-s;s,c];

drawPointArray = R*pointArray*size + tipP*ones(1,4);

%% Plot arrow tip
fill(drawPointArray(1,:), drawPointArray(2,:), color, 'EdgeColor','none')





end

