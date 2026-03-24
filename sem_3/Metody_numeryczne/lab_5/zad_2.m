x1=2;
y1=3;
x2=4;
y2=5;
x0=1;
y0=2;

y=y55(x1,y1,x2,y2); y(1)
y=y56(x1,y1,x2,y2);y(1)
y=y57(x1,y1,x2,y2);y(1)
N=n56(x0,y0,x1,y1,x2,y2);N(3)
L=l57(x0,y0,x1,y1,x2,y2);L(3)


function [y]=y55(x1,y1,x2,y2)
a=((y2-y1)/(x2-x1));
b=((x2*y1)-(x1*y2))/(x2-x1);
y=@(x)(a*x + b);
end

function [y]=y56(x1,y1,x2,y2)
y=@(x)(y1 +((y2-y1)/(x2-x1)*(x-x1)));
end

function [y]=y57(x1,y1,x2,y2)
y=@(x)(((x-x2)/(x1-x2))*y1 + (x-x1)/(x2-x1)*y2);
end

function[N]=n56(x0,y0,x1,y1,x2,y2)
f01 = (y1 - y0) / (x1 - x0); %roznice dzielone
f12 = (y2 - y1) / (x2 - x1);
f012 = (f12 - f01) / (x2 - x0);
N= @(x) y0 + f01 * (x - x0) + f012 * (x - x0) * (x - x1); %obliczenie wielomianu
end

function[L]=l57(x0,y0,x1,y1,x2,y2)
L0 = @(x) ((x - x1) * (x - x2)) / ((x0 - x1) * (x0 - x2));%funkcje wyjsciowee
L1 = @(x) ((x - x0) * (x - x2)) / ((x1 - x0) * (x1 - x2));
L2 = @(x) ((x - x0) * (x - x1)) / ((x2 - x0) * (x2 - x1));
%wielomian lagrange
L = @(x) y0 * L0(x) + y1 * L1(x) + y2 * L2(x);
end

