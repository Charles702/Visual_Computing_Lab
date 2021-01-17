% Harris Corner Detector 
I = imread("harris.jpg");
imshow(I);
I = rgb2gray(I);
I = im2double(I);

%initial sobel filter masks
sobelX = [1,0,-1; 2,0,-2; 1,0,-1]*1/2;
sobelY = [1 2 1; 0 0 0; -1 -2 -1]*1/2;

%compute the gradients
Ix = conv2(I, sobelX, 'same');
Iy = conv2(I, sobelY, 'same');

Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

%Gaussian filter
Ix2 = imgaussfilt(Ix2);
Iy2 = imgaussfilt(Iy2);
Ixy = imgaussfilt(Ixy);

% padding
Ix2p = padarray(Ix2, [1 1]);
Iy2p = padarray(Iy2, [1 1]);
Ixyp = padarray(Ixy, [1 1]);

% Build M.   assume size os window is 3*3

M = 0.5*(Ix2+Iy2 - sqrt(4* Ixy.*Ixy + (Ix2 - Iy2).^2) );

% filter
f1 = ones(3,3);
r_corner = conv2(M, f1, "same");


%threshold
threshold = 0.4;
imshow(r_corner > threshold);

%  question?  How to simplify the 4 layers loops 



