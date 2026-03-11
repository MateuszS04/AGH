clear all;
close all;

A=10;
B=250;
C=-115;
%obliczone z normalnego wzoru
x1=((-B)-sqrt((B^2)-(4*A*C)))/(2*A);
x2=((-B)+sqrt((B^2)-(4*A*C)))/(2*A);
disp("x1="+ x1);
disp("x2="+ x2);
% nowy wzor
if(abs(x1)>=abs(x2))
    x2_new=C/(A*x1);
    diffrence_2=x2-x2_new;
    disp("New x2="+x2)
    disp("Diffrence = "+diffrence_2)
else
X1_new=C/(A*X2);
diffrence_1=X1-x1_new;
disp("New x1="+X1_new);
disp("Diffrence"+diffrence_1);
end
