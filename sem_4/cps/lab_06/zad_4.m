% Wczytaj pliki audio
[x1, fs1] = audioread('engine.wav');
[x2, fs2] = audioread('BLACKBIR.wav');


N = min(length(x1), length(x2));
x1 = x1(1:N);
x2 = x2(1:N);

% suma sygnałów
x_sum = x1 + x2;

plot_fft(x1, fs1, 'Silnik');
plot_spectrogram(x1, fs1, 'Silnik');

plot_fft(x2, fs1, 'Ptak');
plot_spectrogram(x2, fs1, 'Ptak');

plot_fft(x_sum, fs1, 'Suma');
plot_spectrogram(x_sum, fs1, 'Suma');

% Projektowanie filtru IIR 
% low = 100/ (fs1/2);
% high = 1000/ (fs1/2);
low = 2000/ (fs1/2);
high = 3300/ (fs1/2);
order = 6;
[b, a] = butter(order, [low high], 'bandpass');

% Odpowiedź częstotliwościowa filtru
[H, f] = freqz(b, a, 1024, fs1);
figure;
plot(f, 20*log10(abs(H)));
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
title('Odpowiedź częstotliwościowa filtru');

% Zera i bieguny
figure;
zplane(b, a);
title('Zera i bieguny filtru');

% Filtracja sygnału sumy
x_filt = filter(b, a, x_sum);

sound(x_filt, fs1);

audiowrite('filtrowana_mowa.wav', x_filt, fs1);

% FFT i STFT po filtracji
plot_fft(x_filt, fs1, 'Po filtrze');
plot_spectrogram(x_filt, fs1, 'Po filtrze');


function plot_fft(x, fs, titleText)
    N = length(x);
    X = fft(x);
    f = (0:N-1)*(fs/N);
    figure;
    plot(f, abs(X));
    title(['FFT – ', titleText]);
    xlabel('Częstotliwość [Hz]');
    ylabel('|X(f)|');
    xlim([0 fs/2]);
end

function plot_spectrogram(x, fs, titleText)
    figure;
    spectrogram(x, 256, 200, 512, fs, 'yaxis');
    title(['Spektrogram – ', titleText]);
end
