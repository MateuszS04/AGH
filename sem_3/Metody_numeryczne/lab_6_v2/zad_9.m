
fp = 1; 
Tp = 1 / fp; %przedział czasowy

% Generate a range of s values along the imaginary axis
omega = linspace(-10, 10, 400); 
s_values = 1i * omega;

% z użycie 6.40
z_values_640 = 2 * fp * (s_values - 1) ./ (s_values + 1);

% z użyciem 6.41
s_values_641 = 2 * fp * (z_values_640 - 1) ./ (z_values_640 + 1);


figure;

% Plot s-values in the s-plane
subplot(1, 2, 1);
plot(real(s_values), imag(s_values), 'DisplayName', 'Original s');
title('s-plane');
xlabel('Re(s)');
ylabel('Im(s)');
line(xlim, [0 0], 'Color', 'black', 'LineWidth', 0.5); % x-axis
line([0 0], ylim, 'Color', 'black', 'LineWidth', 0.5); % y-axis
grid on;
legend;

% Plot z-values in the z-plane
subplot(1, 2, 2);
plot(real(z_values_640), imag(z_values_640), 'DisplayName', 'Transformed z (6.40)');
hold on;
plot(real(s_values_641), imag(s_values_641), '--', 'DisplayName', 'Back-transformed s (6.41)');
title('z-plane');
xlabel('Re(z)');
ylabel('Im(z)');
line(xlim, [0 0], 'Color', 'black', 'LineWidth', 0.5); 
line([0 0], ylim, 'Color', 'black', 'LineWidth', 0.5); 
grid on;
legend;

hold off;
