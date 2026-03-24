x=[0,pi/4,pi/2];
y=sin(x);

h1=x(2)-x(1);

dy_dx_1 = (1 / (2 * h1)) * (-3 * y(1) + 4 * y(2) - y(3));
dy_dx_2 = (1 / (2 * h1)) * (y(3) - y(1));
dy_dx_3 = (1 / (2 * h1)) * (y(1) - 4 * y(2) + 3 * y(3));

dy_dx_num=[dy_dx_1,dy_dx_2,dy_dx_3];

exact_diff=cos(x);

error_sin=abs(dy_dx_num-exact_diff);
disp("numerical value "+dy_dx_num) %pochodne numeryczne
disp("exact value "+exact_diff)
disp("error "+error_sin)
%dla wielomianu 
x2=[1,2,3];
y2=0.5+x2+2*x2.^2;

h2=x2(2)-x2(1);
dy2_dx_1 = (1 / (2 * h1)) * (-3 * y(1) + 4 * y(2) - y(3));
dy2_dx_2 = (1 / (2 * h1)) * (y(3) - y(1));
dy2_dx_3 = (1 / (2 * h1)) * (y(1) - 4 * y(2) + 3 * y(3));

dy2_dx_num=[dy2_dx_1,dy2_dx_2,dy2_dx_3];

exact_diff2=1+4*x2;
error=abs(dy2_dx_num-exact_diff2);
disp("numerical value "+dy2_dx_num)
disp("exact value" +exact_diff2)
disp("error "+error)

y3=0.5 +x2+2*x2.^2 +3*x2.^3;
dy3_dx_1 = (1 / (2 * h1)) * (-3 * y(1) + 4 * y(2) - y(3));
dy3_dx_2 = (1 / (2 * h1)) * (y(3) - y(1));
dy3_dx_3 = (1 / (2 * h1)) * (y(1) - 4 * y(2) + 3 * y(3));

dy3_dx_num=[dy3_dx_1,dy3_dx_2,dy3_dx_3];

exact_diff3=1+4*x2+9*x2.^2;
error2=abs(dy3_dx_num-exact_diff3);


disp("numerical value"+dy3_dx_num)
disp("exact value"+exact_diff3)
disp("error "+error2)