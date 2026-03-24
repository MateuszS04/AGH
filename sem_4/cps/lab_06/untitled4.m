clear all; close all; clc;

%% Parametry
fs = 3.2e6;         % częstość próbkowania
N  = 32e6;          % liczba próbek (IQ)
fc = 0.50e6;        % częstotliwość środkowa wybranej stacji

bwSERV = 80e3;      % szerokość pasma FM
bwAUDIO = 16e3;     % szerokość pasma audio

%% Odczyt pliku
f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8'); fclose(f);
s = s - 127;
wideband_signal = s(1:2:end) + 1i * s(2:2:end); clear s;

M = 2^20;  % fragment do rysowania widm

%% (1) Widma i spektrogramy
figure;
subplot(2,1,1);
psd(spectrum.welch('Hamming', 1024), wideband_signal(1:M), 'Fs', fs);
title('PSD oryginalnego sygnału szerokopasmowego');

subplot(2,1,2);
spectrogram(wideband_signal(1:M), hamming(1024), 512, 1024, fs, 'yaxis');
title('Spektrogram oryginalnego sygnału szerokopasmowego');

%% (2) Wybór stacji
% Możesz wybrać inną stację zmieniając fc, na przykład:
% fc = 0.3e6; % inna stacja

% Przesunięcie sygnału do zera
n = (0:N-1)';
wideband_signal_shifted = wideband_signal .* exp(-1i*2*pi*fc/fs*n);

% (3) Filtr Butterwortha do ekstrakcji usługi FM
[b, a] = butter(4, (bwSERV/2)/(fs/2));  % filtr dolnoprzepustowy 80kHz
wideband_signal_filtered = filter(b, a, wideband_signal_shifted);

% Widmo po filtracji
figure;
psd(spectrum.welch('Hamming', 1024), wideband_signal_filtered(1:M), 'Fs', fs);
title('PSD po filtrze Butterwortha');

% Downsampling do bwSERV (próbkowanie co fs/(bwSERV*2))
x = wideband_signal_filtered(1:fs/(bwSERV*2):end);
fs2 = bwSERV;

%% Demodulacja FM
dx = x(2:end) .* conj(x(1:end-1));
y = atan2(imag(dx), real(dx));

%% (4) Filtr antyaliasingowy przed decymacją do audio
[bAA, aAA] = butter(4, bwAUDIO/(fs2/2));
y_filtered = filter(bAA, aAA, y);

% Decymacja
decim = fs2 / (2 * bwAUDIO);
ym = y_filtered(1:decim:end);
fs_audio = bwAUDIO * 2;

% (opcjonalnie) porównaj bez antyaliasingu:
% ym_noAA = y(1:decim:end);
% soundsc(ym_noAA, fs_audio); % posłuchaj różnicy

%% (5) De-emfaza i pre-emfaza
% De-emphasis (spadek 20dB/dekadę od 2.1kHz)
[b_de, a_de] = butter(1, 2*pi*2.1e3/fs_audio, 'low');
ym_deemph = filter(b_de, a_de, ym);

% (opcjonalnie) pre-emfaza
[b_pre, a_pre] = butter(1, 2*pi*2.1e3/fs_audio, 'high');
ym_pre = filter(b_pre, a_pre, ym);
ym_pre_de = filter(b_de, a_de, ym_pre);

% Charakterystyki filtrów
fvtool(b_pre, a_pre, b_de, a_de);
legend('Pre-emphasis', 'De-emphasis');

% (opcjonalnie) Posłuchaj porównań
% soundsc(ym, fs_audio);         % bez filtracji
% soundsc(ym_deemph, fs_audio);  % po de-emfazie
% soundsc(ym_pre_de, fs_audio);  % po pre i de-emfazie

%% Normalizacja i odsłuch
ym_out = ym_deemph - mean(ym_deemph);
ym_out = ym_out / (1.001 * max(abs(ym_out)));
soundsc(ym_out, fs_audio);
