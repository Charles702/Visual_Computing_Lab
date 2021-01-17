clear all;

% read image
I = imread('harris.jpg');
I = rgb2gray(I);
I = im2double(I);

% initialize sobel filter masks

% compute gradients

% gaussian filter

% build M

% calculate eigenvalue

% threshold

% display