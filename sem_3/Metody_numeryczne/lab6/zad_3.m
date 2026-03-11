
clear all; close all;

% Measurement data (x = measurement number, y = value)
x = [1 2 3 4 5 6 7 8 9 10];
y = [0.912 0.945 0.978 0.997 1.013 1.035 1.057 1.062 1.082 1.097];

figure; %dane pomiarowe 
plot(x, y, 'b*'); 
title('y=f(x)'); 
xlabel('x');
ylabel('y');
grid on; 


%Aproksymacja linia prosta y=ax+b ogólnie rozwiązanie rówania macierzowego
if (0) 
    xt = x'; 
    yt = y'; 
    N = length(xt); 

    X = [xt, ones(N, 1)]; %
    ab = X \ yt; 
    a = ab(1);
    b = ab(2);
else % wzór na podstawie średnich
    xm = mean(x);
    ym = mean(y); 
    xr = x - xm; % wektory odchyłu od średniej
    yr = y - ym; 
    a = (xr * yr') / (xr * xr'); % współczynnik a
    b = ym - a * xm; % punkt przecięcia z osią y
end


figure; 
plot(x, y, 'b*', x, a*x + b, 'k-'); 
title('y=f(x) linia aproksymacji');
grid on;


%dopasowanie liniowe
p = polyfit(x, y, 1); 
disp(['polyfit 1 a = ', num2str(p(1)), ', b = ', num2str(p(2))]);
diff_a= abs(a-p(1));
disp("diffrence between a from plyfit and a from normal counting :"+ diff_a);

% wykres danych i lini dopasowanej
figure; 
plot(x, y, 'b*', x, polyval(p, x), 'r-'); 
title('y=f(x) and Linear Fit using polyfit');
xlabel('x');
ylabel('y');
grid on; 


%dopasowanie wielomianowe do wyższych stopniem funkcji
for n = 2:4
    p = polyfit(x, y, n); 
    disp(['polyfit ', num2str(n) ,' a= ', num2str(p(1)),'  b= ', num2str(p(2))]);
    figure; 
    plot(x, y, 'b*', x, polyval(p, x), 'r-'); 
    title(['y=f(x) and Polynomial Fit of Degree ', num2str(n)]);
    grid on; 

end
