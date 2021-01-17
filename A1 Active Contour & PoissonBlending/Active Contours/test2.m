clear all; 
close all;
%Parameters initialization 
N = 2000;
alpha = 0.5;  %0.4
beta = 5; %0.2 larger for shape curve 
gamma = 1;
kappa = 0.15; %0.15
Wline = 0.5;  %0.5
Wedge = 1;  %1.0
Wterm = 0.5;  %0.5
sigma = 0.5;
displaySteps = floor(N/10);
I = imread('images/dental.png');
if (ndims(I) == 3)
    I = rgb2gray(I);
end
imshow(I);

%initialzie points 
[x,y] = getpts();
x =min(max(x,1),size(I,2));
y =min(max(y,1),size(I,1));
cpx = [];
cpy = [];
x = [x;x(1)];
y = [y;y(1)];
for i = 1: length(y)-1
    xx = linspace(x(i),x(i+1), 30);
    pp = spline([x(i),x(i+1)],[y(i),y(i+1)]);
    yy = ppval(pp, xx);
    plot(xx,yy);
    hold on;
    cpx = [cpx xx(1:end-1)];
    cpy = [cpy yy(1:end-1)];
end

%convert control point to vertical 
I_smooth = double(imgaussfilt(I, 0.5));
imshow(I_smooth);

%Derivtion of external energies
%Eline
Eline = I_smooth;

%calculate Edge: 
%[Eedge,Gdir] = imgradient(I_smooth);
[grady,gradx] = gradient(I_smooth);
Eedge = -1 * sqrt ((gradx .* gradx + grady .* grady));

%Cacluate Eterm
%Calculate derivative  Cx
fx = [0 0 0;0 -1 1;0 0 0];
Cx = conv2(I_smooth,fx,'same');

%Calculate derivative Cxx
fxx = [0 0 0;1 -2 1;0 0 0];
Cxx = conv2(I_smooth,fxx,'same');

%Calculate derivative Cy
fy = [0 0 0;0 -1 0;0 1 0];
Cy = conv2(I_smooth,fy,'same');

%Calculate derivative Cyy
fyy = [0 1 0;0 -2 0; 0 1 0];
Cyy = conv2(I_smooth,fyy,'same');

%Calculate derivative Cxy
fxy = [0 0 0; 0 1 -1;0 -1 1];
Cxy = conv2(I_smooth,fxy,'same');

% Calculate Eterm
Eterm = (Cyy.*(Cx.^2)-2*Cxy.*Cx.*Cy+ Cxx.*(Cy.^2))./((1+Cx.^2+Cy.^2).^(3/2));
Eext= Wline*Eline + Wedge*Eedge + Wterm * Eterm; 

% Calculate internal energy matrix
Ainv = getInternalEnergyMatrix(size(cpx,2), alpha, beta, gamma);
Ainv1 = getInternalEnergyMatrixBonus(size(cpx,2), alpha, beta, gamma);

[Eextx, Eexty] = gradient(Eext);

cpx = cpx.';
cpy = cpy.';

%Iternation 
for i = 1:N
    kfx = kappa* interp2(Eextx, cpx, cpy);
    kfy = kappa* interp2(Eexty, cpx, cpy);
        
    ssx = Ainv*(gamma*cpx + kfx);
    ssy = Ainv*(gamma*cpy + kfy);
    
    cpx = ssx;
    cpy = ssy;
    
    cpx = min(max(cpx,1),size(I,2));
    cpy = min(max(cpy,1),size(I,1));
    
    imshow(I); 
    
    hold on;
    plot([cpx; cpx(1)], [cpy; cpy(1)], '-r');
    
    % Display step
    if(mod(i,displaySteps)==0)
        fprintf('%d/%d iterations\n',i,N);
    end
    pause(0.0001)
end
    



