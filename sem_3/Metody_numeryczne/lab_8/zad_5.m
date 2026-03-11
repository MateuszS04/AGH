% evd_qr.m
clear all; close all;
%A = randn(5); % 5x5 macierz o losowych elementach
%A = [1 1e-10; 0 1e-10]; % Przykład macierzy z małym wyznacznikiem
if(1) A = [ 4 0.5; 0.5 1 ]; % analizowana macierz
else A = magic(4);
end
[N,N]=size(A); % jej wymiary
x = ones(N,1); % inicjalizacja
[Q,R] = qr(A); % pierwsza dekompozycja QR
for i=1:30 % petla - start
[Q,R] = qr(R*Q); % kolejne iteracje
end % petla -stop
A1 = R*Q; % ostatni wynik
lambda = diag(A1); % elementy na przekatnej
ref = eig(A); % porownanie z Matlabem
disp('Ostatni wynik A1:');
disp(A1);
disp('Wartości własne lambda:');
disp(lambda);
disp('Wartości własne z funkcji eig:');
disp(ref);