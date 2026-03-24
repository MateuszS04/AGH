% Define the cubic B-spline function Bj3 based on the given conditions.
% This function will be evaluated for x values to plot the spline shape.

% Clear the workspace and figures
clear; clc; close all;

% Define the Bj,3 function as an anonymous function of x and xj
Bj3 = @(x, xj) arrayfun(@(xi) ...
    (xi >= -2 + xj && xi < -1 + xj) * ((xi - xj + 2)^3 / 6) + ...
    (xi >= -1 + xj && xi < 0 + xj) * ((-3 * (xi - xj)^3 + 3 * (xi - xj)^2 + 3 * (xi - xj) + 1) / 6) + ...
    (xi >= 0 + xj && xi < 1 + xj) * ((3 * (xi - xj)^3 - 6 * (xi - xj)^2 + 4) / 6) + ...
    (xi >= 1 + xj && xi < 2 + xj) * ((1 - (xi - xj))^3 / 6), ...
    x);

% Define x range for plotting
x_values = -2:0.01:2; % x range from -2 to 2
xj = 0; % Set xj for plotting the cubic B-spline centered at xj = 0

% Calculate Bj3 for the defined x range
Bj3_values = Bj3(x_values, xj);

% Plot the cubic B-spline
figure;
plot(x_values, Bj3_values, 'LineWidth', 2);
xlabel('x');
ylabel('B_{j,3}(x)');
title('Cubic B-spline B_{j,3}(x) centered at x_j = 0');
grid on;

