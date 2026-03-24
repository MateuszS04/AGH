clear all;
close all;
[x,fs_orig]=audioread('DontWorryBeHappy.wav');
x=x(:,1);
x=x/max(abs(x));
duration=5;


if fs_orig ~= 44100
    [p, q] = rat(44100 / fs_orig);
    x = resample(x, p, q);
    fs = 44100;
else
    fs = fs_orig;
end
x=x(1:min(end,duration*fs));
target_bitrate=64000;
N_values=[32,128];%liczba poziomów w kwantyzatorze

for N=128   
        % Q = 1.43;
        Q=1.2;
        [sym, bps] = kodtr(x, N, Q);
        bitrate = bps * fs;

    x_hat=dekodtr(sym,N,Q);
    x_hat = x_hat(1:min(length(x_hat), length(x)));
    x = x(1:min(length(x_hat), length(x)));

    mse = mean((x - x_hat).^2);

    fprintf('Q: %.3f, bps: %.3f, bitrate: %.1f kbps, MSE: %.6e\n', Q, bps, bitrate/1000, mse);
    % soundsc(x_hat, fs); 
end

