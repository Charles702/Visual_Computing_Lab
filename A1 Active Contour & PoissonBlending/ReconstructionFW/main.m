clc;
clear;
close all;

imgin = im2double(imread('./large.jpg'));
figure;
imshow(imgin);

[imh, imw, nb] = size(imgin);
assert(nb==1);
% the image is grayscale

V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;
% V(y,x) = (y-1)*imw + x
% use V(y,x) to represent the variable index of pixel (x,y)
% Always keep in mind that in matlab indexing starts with 1, not 0

%TODO: initialize counter, A (sparse matrix) and b.
A = sparse([],[],[],imh, imw);
b = zeros(imh,1);
e = 1; 

%TODO: fill the elements in A and b, for each pixel in the image
for y = 1 : imh
    for x = 1: imw
        if x == 1 || x== imw    % left or right edge no horizantal derivative
            if y~=1 && y~= imh
                Sl = 0;
                Sr = 0;
                Su = imgin(y,x) - imgin(y-1,x);
                Sd = imgin(y,x) - imgin(y+1,x);  
                
                A(e, V(y,x)) = 2;
                A(e, V(y+1, x)) = -1;
                A(e, V(y-1, x)) = -1;      
                b(e) = Sl + Sr + Su + Sd;  
            end 
        elseif y== 1 || y== imh % up or bottom edge no vertical derivative
            if x~=1 && x~= imw
                Sl = imgin(y,x) - imgin(y,x-1);
                Sr = imgin(y,x) - imgin(y,x+1);  
                Su = 0;
                Sd = 0;
                
                A(e, V(y,x)) = 2;
                A(e, V(y, x-1)) = -1;
                A(e, V(y, x+1)) = -1;
                b(e) = Sl + Sr + Su + Sd;  
            end
        else
            Sl = imgin(y,x) - imgin(y,x-1);
            Sr = imgin(y,x) - imgin(y,x+1); 
            Su = imgin(y,x) - imgin(y-1,x);
            Sd = imgin(y,x) - imgin(y+1,x);  
            
            A(e, V(y,x)) = 4;
            A(e, V(y+1, x)) = -1;
            A(e, V(y-1, x)) = -1;                
            A(e, V(y, x-1)) = -1;
            A(e, V(y, x+1)) = -1;
            b(e) = Sl + Sr + Su + Sd;  
        end   
        e = e+1;      
    end
end
%-----

%TODO: add extra constraints

% (1,1)
A(e, V(1,1)) = 1;
b(e) = imgin(1,1);
e = e+1;
%(1,imw)
A(e, V(1,imw)) = 1;
b(e) = imgin(1,imw);
e = e+1
%(imh, 1)
A(e, V(imh,1)) = 1;
b(e) = imgin(imh,1);
e = e+1
%(imh, imw)
A(e, V(imh, imw)) = 1;
b(e) = imgin(imh, imw);
%-----

 
%TODO: solve the equation
%use "lscov" or "\", please google the matlab documents
solution = A\b;
error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);

imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);
