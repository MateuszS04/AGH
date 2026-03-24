 % przykład 15.1: Demonstracja kodowania podpasmowego

clc; clear; close all
[x,Fs] = audioread('DontWorryBeHappy.wav'); 	% Wczytanie sygnału z pliku wav
% soundsc(x,Fs) 
x=x(:,1);
start_time=5;
end_time=10;
start_sample=round(start_time*Fs);
end_sample=round(end_time*Fs);
x=x(start_sample:end_sample);

figure; spectrogram(x, 2048, [], [], Fs, 'yaxis'); title('Oryginał');               % demonstracja spektrogramu
title('Sygnał oryginalny')

% Zakodowanie koderem podpasmowym z użyciem 8 podpasm i 6 bitów na próbkę
% UWAGA: przed skwantowaniem każde pasmo jest normalizowane do zakresu –1..1
% [y2,bps2] = kodowanie_podpasmowe(x,8,6);
[y2,bps2] = kodowanie_podpasmowe_dynamiczne(x,8,[]);
% soundsc(y2,Fs)
figure(2)
specgram(y2,2048,Fs,2000)
title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps2))

% Zakodowanie koderem podpasmowym z użyciem 32 podpasm i 8 bitów na próbkę
% [y3,bps3] = kodowanie_podpasmowe(x,32,6);
[y3,bps3] = kodowanie_podpasmowe_dynamiczne(x,32,[]);
% soundsc(y3,Fs)
figure(3)
specgram(y3,2048,Fs,2000)
title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps3))

% % Zakodowanie koderem podpasmowym z użyciem 16 podpasm i zmiennej liczby bitów na próbkę
% [y4,bps4] = kodowanie_podpasmowe(x,32,[8 8 7 6 repmat(4,1,28)]);
% % soundsc(y4,Fs)
% figure(4)
% specgram(y4,2048,Fs,2000)
% title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps4))

% PCM przebiegi czasowe
figure;
subplot(4,1,1); plot(x); title('PCM: oryginał');
subplot(4,1,2); plot(y2); title('PCM: 8 pasm, 6 bitów');
subplot(4,1,3); plot(y3); title('PCM: 32 pasma, 6 bitów');
% subplot(4,1,4); plot(y4); title('PCM: 32 pasma, zmienne bity');

% Kompresja
fprintf('Kompresja (względem 16-bit PCM)  \n');
% fprintf('Wariant 1 (8 pasm, 6 bitów): %.2f%% redukcji bitów\n', 100 * (1 - bps2 / 16));
% fprintf('Wariant 2 (32 pasma, 6 bitów): %.2f%% redukcji bitów\n', 100 * (1 - bps3 / 16));
% fprintf('Wariant 3 (32 pasma, zmienne bity): %.2f%% redukcji bitów\n', 100 * (1 - bps4 / 16));
fprintf('Wariant 1 (8 pasm, dynamiczne przydzielanie bitów): %.2f%% redukcji bitów\n', 100 * (1 - bps2 / 16));
fprintf('Wariant 2 (32 pasma, dynamiczne przydzielanie bitów): %.2f%% redukcji bitów\n', 100 * (1 - bps3 / 16));