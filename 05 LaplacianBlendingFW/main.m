clear all;
close all;

% load images
img1 = imread('images/1.png');
if (ndims(img1) == 3)
    img1 = rgb2gray(img1);
end
img2 = imread('images/2.png');
if (ndims(img2) == 3)
    img2 = rgb2gray(img2);
end
imgM = imread('images/M.png')/255;
if (ndims(imgM) == 3)
    imgM = rgb2gray(imgM);
end

% build gaussian pyramid of image 1
gp1 = GaussianPyramid(img1, 6);
DisplayPyramid(gp1);

% build laplacian pyramid of image 1
lp1 = LaplacianPyramid(gp1);
DisplayPyramid(lp1);

% reconstruct image 1 using laplacian pyramid
figure;
imshow(LaplacianReconstruct(lp1));

% blend images 1 and 2 using mask M

% ...
%I = Blend(...
figure;
imshow(I);
