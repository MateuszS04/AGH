clear all; close all;

fs = 3.2e6;         % sampling frequency
N  = 32e6;          % number of samples (IQ)
fc = 0.50e6;        % central frequency of MF station

bwSERV = 80e3;      % bandwidth of an FM service
bwAUDIO = 16e3;     % bandwidth of an FM audio

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s - 127;

% IQ --> complex
wideband_signal = s(1:2:end) + 1i * s(2:2:end); 
clear s;

% WIDMO + WYKRES CZASOWY, sygnał wyjściowy z wieloma stacjami
figure; 
psd(spectrum.welch('Hamming',1024), wideband_signal, 'Fs', fs); 
title('Widmo mocy - sygnał szerokopasmowy');

figure;
plot(real(wideband_signal(1:1e4))); 
title('Przebieg czasowy - sygnał szerokopasmowy');
xlabel('Próbki'); ylabel('Amplituda');

% Extract carrier of selected service, then shift in frequency the selected service to
%the baseband
wideband_signal_shifted = wideband_signal .* exp(-1i*2*pi*fc/fs*(0:N-1)');
%przesuwamy interesujące nas częstotliwości do zera Hz aby łatwiej wyciąć
%je filtrem niskoprzepustwym

figure;
psd(spectrum.welch('Hamming',1024), wideband_signal_shifted, 'Fs', fs);
title('Widmo mocy - po przesunięciu częstotliwości');

figure;
plot(real(wideband_signal_shifted(1:1e4)));
title('Przebieg czasowy - po przesunięciu częstotliwości');
xlabel('Próbki'); ylabel('Amplituda');

% Filter out the service from the wide-band signal (1)
%filtracja pasmowa (filtr donoprzepustowy 4 rzędu o paśmie 80kHz)
%ten fragment wycina jedną stację z szerokiego pasma
[b, a] = butter(4, (80e3)/(fs/2));
wideband_signal_filtered = filter(b, a, wideband_signal_shifted);

figure;
psd(spectrum.welch('Hamming',1024), wideband_signal_filtered, 'Fs', fs);
title('Widmo mocy - po filtracji pasmowej');

figure;
plot(real(wideband_signal_filtered(1:1e4)));
title('Przebieg czasowy - po filtracji pasmowej');
xlabel('Próbki'); ylabel('Amplituda');

% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered(1 : fs/(bwSERV*2) : end);
%zmniejszamy częstotliwość próbkowanie do 160kHz 
%spełniamy tym warunke Nyquista, chcemy tylko jedną stację
fs_SERV = bwSERV * 2;

figure;
psd(spectrum.welch('Hamming',1024), x, 'Fs', fs_SERV);
title('Widmo mocy - po decymacji do bwSERV');

figure;
plot(x(1:1e4));
title('Przebieg czasowy - po decymacji do bwSERV');
xlabel('Próbki'); ylabel('Amplituda');

% FM demodulation
dx = x(2:end) .* conj(x(1:end-1));
y = atan2(imag(dx), real(dx));
%demodelujemy FM: różniczkowoanie fazy
%y to teraz sygnał audio zakodowany fazowo
figure;
psd(spectrum.welch('Hamming',1024), y, 'Fs', fs_SERV);
title('Widmo mocy - po demodulacji FM');

figure;
plot(y(1:1e4));
title('Przebieg czasowy - po demodulacji FM');
xlabel('Próbki'); ylabel('Amplituda');

% Decimate to audio signal bandwidth bwAUDIO (2)
% Filtr Lp zapobiega aliasingowi przy decymacji 5:1, brak filtra spowoduje
% mieszanie wyższych częstotliwości i zniekształcenia 
[b_anty, a_anty] = butter(4, (16e3)/(bwSERV));  
y_filtered = filter(b_anty, a_anty, y);     
ym = y_filtered(1:5:end); 
fs_AUDIO = bwAUDIO * 2;

figure;
psd(spectrum.welch('Hamming',1024), ym, 'Fs', fs_AUDIO);
title('Widmo mocy - sygnał audio (po filtracji i decymacji)');

figure;
plot(ym(1:1e4));
title('Przebieg czasowy - sygnał audio (po filtracji i decymacji)');
xlabel('Próbki'); ylabel('Amplituda');

%De-emfaza, flat characteristics to 2.1 kHz, then falling 20 dB/decade
tau = 75e-6;
alpha = exp(-1/(fs_AUDIO * tau));
b_de = 1 - alpha;
a_de = [1 -alpha];
ym = filter(b_de, a_de, ym);

% --- Znalezienie "górek" widma mocy ---
[pxx, f_pxx] = pwelch(wideband_signal, 1024, 512, 1024, fs);
pxx_dB = 10*log10(pxx);
threshold = max(pxx_dB) - 15; 
[~, locs] = findpeaks(pxx_dB, 'MinPeakHeight', threshold);
f_stacje = f_pxx(locs);

disp('Znalezione częstotliwości stacji FM (w Hz):');
disp(f_stacje);
% Listen to the final result
ym = ym-mean(ym); ym = ym/(1.001*max(abs(ym)));
soundsc( ym, fs_AUDIO);
