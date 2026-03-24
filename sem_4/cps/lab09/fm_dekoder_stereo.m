clear all; close all; clc;

% --- PARAMETRY ---
usePLL = true;  % <<== PRZEŁĄCZNIK: true = PLL, false = bez PLL
fpilot = 19e3;      % częstotliwość pilota
fstereo = 2 * fpilot;
bwSERV = 250e3;
Abw = 15e3;         % audio bandwidth
L = 127;            % długość filtrów FIR

% --- WCZYTANIE SYGNAŁU ---
load stereo_fm_broken_pilot_b.mat  % sygnał testowy z uszkodzonym pilotem
y = I + 1i*Q;
fs = 1e6;           % 1 MHz
N = length(y);

% --- DEMODULACJA ---
y = y .* exp(-1i * 2*pi*bwSERV/fs * (0:N-1)');
[b,a] = butter(4, bwSERV/(fs/2));
y = filter(b, a, y);
y = y(1 : fs/bwSERV : end);
fs = bwSERV;

% --- DEMODULACJA FM (fazowa różnica próbek) ---
dy = y(2:end) .* conj(y(1:end-1));
y = atan2(imag(dy), real(dy));

% --- Filtr L+R (MONO) ---
hLPaudio = fir1(L, (Abw/2)/(fs/2), kaiser(L+1,7));
ym = filter(hLPaudio, 1, y);
ym = ym(1:fs/Abw:end);

% --- PILOT 19kHz (wyodrębnienie) ---
fcentr = fpilot; df1 = 1000; df2 = 2000;
ff = [0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2]/(fs/2);
fa = [0 0.01 1 1 0.01 0];
hBP19 = firpm(L, ff, fa);
p = filter(hBP19,1,y);

% --- GENERACJA NOŚNEJ 38kHz ---
N = length(y); t = (0:N-1)' / fs;
if usePLL
    [~,theta] = PLL(p, fpilot, fs);
    c38 = cos(2*theta);  % z PLL
else
    % Możesz tu zmieniać parametry testowe
    % f_offset = 1; phi = pi/4; % np. dla testów
    f_offset = 0; phi = 0;     % brak błędów
    c38 = cos(2*pi*(2*fpilot + f_offset)*t + phi);  % bez PLL
end

% --- Filtr L-R (38kHz pasmowy) ---
fcentr = fstereo; df1 = 10000; df2 = 12500;
ff = [0 fcentr-df2 fcentr-df1 fcentr+df1 fcentr+df2 fs/2]/(fs/2);
fa = [0 0.01 1 1 0.01 0];
hBP38 = firpm(L,ff,fa);
ys = filter(hBP38, 1, y);

% --- Przesunięcie do DC (mnożenie z nośną) ---
min_len = min(length(ys), length(c38));
ys = ys(1:min_len);
c38 = c38(1:min_len);
ys = real(ys .* c38);


% --- Filtracja L-R ---
ys = filter(hLPaudio, 1, ys);
ys = ys(1:fs/Abw:end);

% --- Synchronizacja opóźnień ---
delay = (L/2)/(fs/Abw);
ym = ym(1:end-delay);
ys = 2 * ys(1+delay:end);  % ×2: odzyskiwanie L-R z DSB-SC

% --- Rekonstrukcja kanałów stereo ---
yL = 0.5 * (ym + ys);
yR = 0.5 * (ym - ys);

% --- WYKRESY ---
figure;
plot(1:length(yL), yL, 'b', 1:length(yR), yR, 'r'); legend('Left', 'Right');
title(['Separacja kanałów stereo, PLL = ', num2str(usePLL)]);

figure;
plot(yL, 'b'); hold on; plot(yR, 'r'); legend('L','R');
title('Kanały stereo w domenie czasu');

% --- SPEKTROGRAM SYGNAŁU HYBRYDOWEGO ---
figure;
spectrogram(real(y), 1024, 768, 1024, fs, 'yaxis');
title('Spektrogram sygnału hybrydowego (kanał FM)');
