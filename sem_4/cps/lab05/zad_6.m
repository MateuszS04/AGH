clear all; close all; clc;

% Parametry
fc = 1000;  % Hz
C = 100e-9; % F
R_ideal = 1 / (2 * pi * fc * C);     % ≈ 1.5915 kΩ
R_e24 = 1.6e3;                       % z szeregu E24

% Systemy transmitancji
s = tf('s');

H_ideal = 1 / (R_ideal^2 * C^2 * s^2 + 3*R_ideal*C*s + 1);
H_real  = 1 / (R_e24^2 * C^2 * s^2 + 3*R_e24*C*s + 1);

% Wykresy
f = logspace(2,5,1000); % od 100 Hz do 100 kHz
w = 2*pi*f;

[mag_ideal, ~] = bode(H_ideal, w);
[mag_real, ~]  = bode(H_real, w);

mag_ideal = squeeze(20*log10(mag_ideal));
mag_real  = squeeze(20*log10(mag_real));

% Wykres
figure;
semilogx(f, mag_ideal, 'b-', 'LineWidth', 2); hold on;
semilogx(f, mag_real, 'r--', 'LineWidth', 2);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)| [dB]');
title('Charakterystyka amplitudowa filtra Butterwortha');
legend('Idealny', 'Z dopasowanymi R z E24');

% Sprawdzenie odchyłki 3 dB
delta = abs(mag_ideal - mag_real);
max_diff = max(delta);
fprintf("Maksymalna różnica: %.2f dB\n", max_diff);

if max_diff <= 3
    disp("Zmiana charakterystyk mieści się w granicy 3 dB");
else
    disp("Zmiana charakterystyk przekracza 3 dB");
end
