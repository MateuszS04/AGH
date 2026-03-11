 % oblicz_pi.m
clear all; close all;
format long;
N = 10000000; % liczba strzalow
Nk = 0; % liczba trafien w kolo
for i = 1 : N % PETLA: kolejne strzaly
x = rand(1,1)*2.0 - 1.0; % # kwadrat o boku 2
y = rand(1,1)*2.0 - 1.0; % #
if( sqrt( x*x + y*y ) <= 1.0) % kolo o promieniu 1
Nk = Nk + 1; % zwieksz liczbe trafien o 1
end %
end %
pi, % dokladne pi
mypi = 4.0 * Nk / N; % obliczone pi
xy = 2*rand(N,2)-1.0;
Nk = numel( find( sqrt(xy(:,1).^2 + xy(:,2).^2) <= 1 ) );
mypi_1 = 4.0 * Nk / N; % obliczone pi
disp('obliczone pi_1')
disp(mypi_1)

% Funkcja obliczająca przybliżenie pi z wykorzystaniem generatora kongruentnego
clear all; close all;
format long;

N = 10000000; % liczba strzałów
Nk = 0; % liczba trafień w koło

% Parametry generatora kongruentnego
seed = 12345; % ziarno startowe

% Generowanie losowych liczb za pomocą funkcji rand_multadd
x = rand_multadd(N, seed) * 2 - 1; % losowe x w przedziale [-1, 1]
y = rand_multadd(N, seed + 1) * 2 - 1; % losowe y w przedziale [-1, 1]

% Liczenie liczby trafień w koło
for i = 1:N
    if sqrt(x(i)^2 + y(i)^2) <= 1.0
        Nk = Nk + 1; % zwiększenie liczby trafień
    end
end

% Przybliżenie wartości pi
mypi_k = 4.0 * Nk / N;

% Wyświetlenie wyników
disp('Obliczone pi_k:');
disp(mypi_k);



