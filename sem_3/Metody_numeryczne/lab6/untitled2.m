% Przybliżenie Padégo dla funkcji f(x) = (1 + x^2)^(-1)

clc; clear; close all;


f = @(x) 1 ./ (1 + x.^2);

x = linspace(-5, 5, 500);% x

% Obliczanie dokładnej funkcji
exact_f = f(x);

% 1. Rozwinięcie Taylora wokół x = 0 f(x)= f'(0)+ (x-a)^2/n! * f(kolejna
% pochodna)
% Taylor dla f(x) = (1 + x^2)^(-1): f(x) = 1 - x^2 + x^4 +.. itd.
 taylor_f = @(x) 1 - x.^2;


% postać padégo : f(x) = (a0 + a1*x^2) / (1 + b1*x^2)
% Dopasowanie współczynników z rozwinięcia Taylora
a0 = 1; % pierwszy wyraz Taylora
a1 = -0.5; % współczynnik x^2 w liczniku
b1 = 0.5; % współczynnik x^2 w mianowniku

pade_f = @(x) (a0 + a1 * x.^2) ./ (1 + b1 * x.^2);

% Obliczanie wartości przybliżeń
taylor_approx = taylor_f(x);
pade_approx = pade_f(x);

% Wykres porównawczy
figure;
plot(x, exact_f, 'k', 'LineWidth', 2); 
hold on;
plot(x, taylor_approx, 'r', 'LineWidth', 1.5);
plot(x, pade_approx, 'b.', 'LineWidth', 1.5);
grid on;
legend('Dokładna funkcja', 'Taylor ', 'Padé ', 'Location', 'Best');
title(' Dokładna funkcja, Taylor, Padé ');
