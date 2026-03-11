clear all; close all;
if(1) A = [ 4 0.5; 0.5 1 ]; % wybor/definicja symetrycznej macierzy kwadratowej
else A = magic(4);
end
[ N, N ] = size(A); % wymiar
x = ones(N,1); % inicjalizacja
for i = 1:20 % poczatek petli
y = A*x; % pierwsze mnozenie
[ymax,imax] = max(abs(y)); % najwieksza wartosc abs() i jej indeks
x = y/ymax; % wektor wlasny
lambda = ymax; % wartosc wlasna
end % koniec petli
x=x/norm(x,2);%normalizacja wektora własnego do normy 2

disp('Wektor własny x znormalizowany');
disp(x);
disp('Największa wartość własna lambda:');
disp(lambda);
lambda; % pokaz wynik: max wartosc wlasna i wektor wlasny
[ V, D ] = eig(A) % porownaj z funkcja Matlaba


%bład pojawia się przy normalizacji wektora x, metoda potęgowa normalizuje
%x względem wektora y tak aby jego największy element miał wartość 1, a metoda wbudowana eig
%zawiera wektory własne normalizowane do normy 2(długość wektora 1)