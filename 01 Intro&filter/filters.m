I = imread('cameraman.tif');
I =imgaussfilt(I);
sobelX = [1,0,-1; 2,0,-2; 1,0,-1]*1/2;
sobelY = [1 2 1; 0 0 0; -1 -2 -1]*1/2;

blur = 1/9*[1,1,1; 1,1,1; 1,1,1];

%blurr
b_I = conv2(I, blur, 'same');
%sobel X
imgX = conv2(I, sobelX, 'same');
%sobel Y
imgY = conv2(I, sobelY, 'same');
%sobel edge detection
sobelXY = sqrt(imgX.^2+imgY.^2);

%normalize results
imgX = imgX/max(imgX(:));
imgY = imgY/max(imgY(:));
imgb = b_I/max(b_I(:));
sobelXY = sobelXY/max(sobelXY(:));

figure;
imshow(imgX);
figure;
imshow(imgY);
figure;
imshow(imgb);
figure;
imshow(sobelXY);
