function outimge = poisson_blend(im_s, mask_s, im_t)
% -----Input
% im_s     source image (object)
% mask_s   mask for source image (1 meaning inside the selected region)
% im_t     target image (background)
% -----Output
% imgout   the blended image
[imh, imw, nb] = size(im_s);
V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;
outimge = zeros(size(im_s));

figure; imshow(im_s);
figure; imshow(mask_s);

%TODO: consider different channel numbers
for c = 1:nb
%TODO: initialize counter, A (sparse matrix) and b.
%Note: A don't have to be k**k,
%      you can add useless variables for convenience,
%      e.g., a total of imh*imw variables
    A = sparse([],[],[],imh, imw);
    b = zeros(imh, 1);
    e = 1;
    
    %TODO: fill the elements in A and b, for each pixel in the imag
    for y = 1: imh
        for x = 1:imw
            if mask_s(y, x) == 1
                A(e, V(y,x)) = 4;
                A(e, V(y,x-1)) = -1;
                A(e, V(y,x+1)) = -1;
                A(e, V(y+1, x)) = -1;
                A(e, V(y-1, x)) = -1;
                
                %left pixel out of region
                Sl = im_s(y,x,c) - im_s(y,x-1,c); 

                %right pixel outisde region
                Sr = im_s(y,x,c) - im_s(y,x+1,c);               
                
                %top pixel outside region
                Su = im_s(y,x,c) - im_s(y-1,x,c);
                
                %down pixcel outside region
                Sd = im_s(y,x,c) - im_s(y+1,x,c);           
                
                b(e) =Sl + Sr + Su + Sd;
                e = e+1;
            elseif mask_s(y, x) ==0 && im_s(y,x,c)~= 0
                A(e, V(y,x)) = 1;
                b(e) = im_t(y,x,c);
                e = e+1;
            end
        end
    end
    %TODO: add extra constraints (if any)
    %TODO: solve the equation
    %use "lscov" or "\", please google the matlab documents
    solution = A\b;
    error = sum(abs(A*solution-b));
    disp(error)
    
    %copy patch to target image
    k=1;
    for y = 1: imh
        for x = 1:imw
            if im_s(y,x,c)~= 0
                im_t(y,x,c) =  solution(V(y,x));
                k = k+1;
            end
        end
    end
    
    %chanelout = reshape(solution,[imh,imw]);
    %figure; imshow(im_t(:,:,c));
    outimge(:,:,c) = im_t(:,:,c);
end

%TODO: copy those variable pixels to the appropriate positions
%      in the output image to obtain the blended image
%imgout = mask_s.*imgblend + (1-mask_s).* im_t;
%imwrite(outimge,'output.png');
%figure(), hold off, imshow(outimge);

