clear;
load("lab08_fm.mat");

fs = 2e6;
fc = 200e3;

% --- FIRLS: projekt pasmowo-różniczkującego filtru ---
N = 400;  % długość filtru (większa niż poprzednio)
f_low = 100e3;
f_high = 300e3;

% Normalizacja
f = [0 f_low f_low f_high f_high fs/2]/(fs/2);

% Amplituda różniczkująca w paśmie
a = [0 0 2*pi*f_low 2*pi*f_high 0 0] / (2*pi*fs/2);

h_firls = firls(N, f, a);  % projekt FIR

% --- Filtracja ---
y = filter(h_firls, 1, x);

% --- Obwiednia ---
y = y.^2;
hLP = fir1(250, 8e3/(fs/2), 'low', kaiser(251, 8));
y = filter(hLP, 1, y);
y = sqrt(y);
y = resample(y, 8000, fs);

% --- Odsłuch i wykres ---
soundsc(real(y), 8000);
t = (0:length(y)-1)/8000;
figure;
plot(t, y);
title("Filtr zaprojektowany przez firls (różniczkujący BP)");
xlabel("Czas [s]");
ylabel("Amplituda");
grid on;