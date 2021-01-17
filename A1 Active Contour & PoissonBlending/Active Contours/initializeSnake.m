function [cpx, cpy] = initializeSnake(I)

% Show figure
imshow(I);
hold on;

% Get initial points

[x,y] = getpts();
% Clamp points to be inside of image
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
end