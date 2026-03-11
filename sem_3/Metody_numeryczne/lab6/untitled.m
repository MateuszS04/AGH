clc; clear; close all;

% Function definition
f = @(x) 1 ./ (1 + x.^2);

% x values
x = linspace(-5, 5, 500);

% Exact function calculation
exact_f = f(x);

% Taylor series approximation (up to x^8 term)
taylor_f = @(x) 1 - x.^2 + x.^4 - x.^6 + x.^8;

% Padé approximation coefficients for a higher order approximation
% We will use a similar form but with higher-order coefficients.
% For simplicity, assume the same coefficients as in Taylor series

% Approximation form: f(x) = (a0 + a1*x^2 + a2*x^4) / (1 + b1*x^2 + b2*x^4)
a0 = 1;
a1 = -1;
a2 = 1;
a3 = -1;
a4 = 1;
b1 = 1;
b2 = -1;
b3 = 1;
b4 = -1;

pade_f = @(x) (a0 + a1 * x.^2 + a2 * x.^4 + a3 * x.^6 + a4 * x.^8) ./ (1 + b1 * x.^2 + b2 * x.^4 + b3 * x.^6 + b4 * x.^8);

% Calculating approximations
taylor_approx = taylor_f(x);
pade_approx = pade_f(x);

% Plotting
figure;
plot(x, exact_f, 'k', 'LineWidth', 2); 
hold on;
plot(x, taylor_approx, 'r', 'LineWidth', 1.5);
% plot(x, pade_approx, 'b.', 'LineWidth', 1.5);
grid on;
legend('Exact Function', 'Taylor Approximation', 'Padé Approximation', 'Location', 'Best');
title('Comparison of Exact Function, Taylor, and Padé Approximations');
