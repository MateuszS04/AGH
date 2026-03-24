clear all;
close all;

[x,fs_orig] = audioread('DontWorryBeHappy.wav');
x = x(:,1);                           % wybieramy sygnał mono z pliku
x = x / max(abs(x));                 % normalizacja
duration = 5;

% Uresampling na częstotliwość nam odpowiadającą
if fs_orig ~= 44100
    [p, q] = rat(44100 / fs_orig);
    x = resample(x, p, q);
    fs = 44100;
else
    fs = fs_orig;
end
x = x(1:min(end, duration * fs));
N=32;
% N = 128;                             % liczba poziomów kwantyzacji
target_bitrate = 64000;             % w bitach na sekundę
tol = 50;                            % tolerancja błędu bitrate
max_iter = 20;
Q = 0.1;                             % początkowy współczynnik sklaujący
mse_threshold = 1e-12;


Q_list = [];
bitrate_list = [];
mse_list = [];

for i = 1:max_iter
    [sym, bps] = kodtr(x, N, Q);
    bitrate = bps * fs;
    x_hat = dekodtr(sym, N, Q);

    len = min(length(x), length(x_hat));
    x_trimmed = x(1:len);
    x_hat = x_hat(1:len);

    mse = mean((x_trimmed - x_hat).^2);
    err_max = max(abs(x_trimmed - x_hat));

    Q_list(end+1) = Q;
    bitrate_list(end+1) = bitrate;
    mse_list(end+1) = mse;

    fprintf('Iteracja %d: Q=%.5f | bitrate=%.1f kbps | MSE=%.2e | max|err|=%.2e\n', ...
        i, Q, bitrate/1000, mse, err_max);


    if mse < mse_threshold && abs(bitrate - target_bitrate) < tol
        disp(' Znaleziono Q zapewniające bezstratność i docelowy bitrate.');
        break;
    end

    Q = Q * 1.4;
end


figure;
subplot(2,1,1);
plot(Q_list, mse_list, '-o');
xlabel('Q'); ylabel('MSE');
title('Błąd rekonstrukcji vs Q'); grid on;
set(gca, 'YScale', 'log');

subplot(2,1,2);
plot(Q_list, bitrate_list / 1000, '-s');
xlabel('Q'); ylabel('Bitrate [kbps]');
title('Bitrate vs Q'); grid on;


