% cps_01_sinus.m'
clear all; close all;
t=10;
fpr=44100; Nx=fpr*t; % parametry: czestotliwosc probkowania, liczba probek
dt = 1/fpr; % okres probkowania
n = 0 : Nx-1; % numery probek
t = dt*n; % chwile probkowania
A1=1; f1=10; p1=0; % sinusoida: amplituda, czestotliwosc, faza
fd=1;
%przyrost częstotliwości na sekunde
f=n*(fd/fpr) +f1;
x1 = A1*sin(2*pi*f.*t+p1); % pierwszy skladnik sygnalu
% x1 = A1*sin(2*pi*f1/fpr*n+p1); % pierwszy skladnik inaczej zapisany
% x2 = ?; % drugi skladnik
% x3 = ?; % trzeci skladnik
x = x1; % wybor skladowych: x = x1, x1 + 0.123*x2 + 0.456*x3
sound(x1,fpr);
pause(t);
plot(t,x); grid; title("Sygnal x(t)"); xlabel("Czas [s]"); ylabel("Amplituda");