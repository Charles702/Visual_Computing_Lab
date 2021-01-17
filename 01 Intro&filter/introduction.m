x = 0:0.1:2*pi;
y =exp(-x).*cos(3*x);
plot(x,y);

a= imread("pout.tif");
figure;
imhist(a)

a_eq = histeq(a);
figure;
imhist(a_eq)
