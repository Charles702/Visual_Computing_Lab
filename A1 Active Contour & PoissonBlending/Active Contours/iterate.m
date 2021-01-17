function [X, Y] = iterate(Ainv, x, y, Eext, gamma, kappa)

% Get fx and fy
[Eextx, Eexty] = gradient(Eext);

kfx = kappa* interp2(Eextx, x, y);
kfy = kappa* interp2(Eexty, x, y);
        
ssx = Ainv*(gamma*x + kfx);
ssy = Ainv*(gamma*y + kfy);
    
X = ssx;
Y = ssy;
    
X = min(max(X,1),size(Eextx,2));
Y = min(max(Y,1),size(Eexty,1));

% lamp to image size
%X =min(max(X,1),size(fx,1));
%Y =min(max(Y,1),size(fy,2));
end
