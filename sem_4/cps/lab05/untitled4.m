% Ręcznie wpisany LP eliptyczny (prototyp)

z_lp = [1j*1.406, -1j*1.406]; % zera (na osi urojonej)

% Bieguny:
p_lp = [-0.252 + 1j*0.965, -0.252 - 1j*0.965, ...
        -0.765 + 1j*0.411, -0.765 - 1j*0.411, ...
        -0.959]; % bieguny (lewa półpłaszczyzna)

% Tworzenie liczników i mianowników z wielomianów
num_lp = poly(z_lp); % współczynniki licznika
den_lp = poly(p_lp); % współczynniki mianownika

% Normalizacja stałą wzmocnienia na 0 Hz = 1
k_lp = real(polyval(den_lp, 0)/polyval(num_lp, 0));
num_lp = k_lp * num_lp;

% Transformacja LP → BP
f1 = 95.9e6;
f2 = 96.1e6;
Bw = (f2 - f1)*2*pi;
w0 = sqrt(2*pi*f1 * 2*pi*f2);

[b_bp, a_bp] = lp2bp(num_lp, den_lp, w0, Bw);

% Charakterystyka
freq = linspace(95.5e6, 96.5e6, 2000);
w = 2*pi*freq;
h = freqs(b_bp, a_bp, w);

% Wykres
figure;
plot(freq, 20*log10(abs(h)), 'LineWidth', 1.5);
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('Wzmocnienie [dB]');
title('Filtr eliptyczny BP (ręcznie podany prototyp LP)');
hold on;
yline(-3, '--r');
yline(-40, '--k');
xline(f1, '--g', [num2str(f1/1e6), ' MHz']);
xline(f2, '--g', [num2str(f2/1e6), ' MHz']);

legend('Wzmocnienie', '-3 dB', '-40 dB', 'Pasmo przepustowe');
