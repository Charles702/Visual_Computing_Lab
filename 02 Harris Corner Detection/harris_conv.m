clear all;

% read image
I = imread('harris.jpg');
I = rgb2gray(I);
I = im2double(I);

% initialize sobel filter masks
sobelX = [1 0 -1; 2 0 -2; 1 0 -1];
sobelY = [1 2 1; 0 0 0; -1 -2 -1];

% convolute
Ix = conv2(I, sobelX, 'same');
Iy = conv2(I, sobelY, 'same');

Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

% gaussian filter
Ix2 = imgaussfilt(Ix2);
Iy2 = imgaussfilt(Iy2);
Ixy = imgaussfilt(Ixy);

% sum up M over window using conv2
M11 = Ix2;
M12 = Ixy;
M21 = M12;
M22 = Iy2;

sumFilter = [1 1 1; 1 1 1; 1 1 1];

M11sum = conv2(M11, sumFilter, 'same');
M12sum = conv2(M12, sumFilter, 'same');
M21sum = conv2(M21, sumFilter, 'same');
M22sum = conv2(M22, sumFilter, 'same');

% calculate minimal eigenvalue
l2 = .5 * ((M11sum + M22sum) - sqrt((4*M12sum.*M21sum) + (M11sum - M22sum).^2));

% threshold
threshold = 0.5;
imshow(l2>threshold)
