clear all;

%parameters
sigma     = 2;
threshold = 0.2;
rhoRes    = 1;
thetaRes  = pi/360;

% Load image

% Convert to grayscale and scale to [0,1]

% Gaussian filter

% Edge filter - use edge()

% Hough transform
[H] = houghTransform(I, threshold, rhoRes, thetaRes);

% Show normalized H
imshow(H/max(H(:))*255)
