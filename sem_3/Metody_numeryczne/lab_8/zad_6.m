% svd_ar.m
clear all; close all;
N = 200; % liczba analizowanych probek danych
fpr = 10000; dt = 1/fpr; % liczba probek danych na sekunde, okres probkowania
f = [ 1000 2000 3000 ]; % liczba powtorzen na sekunde skladowych sinusoidalnych
d = [ 1 10 20 ]; % tlumienie kolejnych skladowych
A = [ 1 0.5 0.25 ]; % amplituda kolejnych skladowych
K = length(f); % liczba skladowych sygnalu
x = zeros(1,N); % inicjalizacja danych
for k = 1 : K % generacja i akumulacja kolejnych sinusoid
x = x + A(k) * exp(-d(k)*(0:N-1)*dt) .* cos(2*pi*f(k)*(0:N-1)*dt + pi*rand(1,1));
end
SNR = 60; x = awgn(x,SNR); % dodanie szumu, poziom w decybelach
figure; plot(x); grid; title(’x(n)’); pause % pokazanie sygnalu
[fest1, dest1 ] = fLP(x,K,dt), % metoda LP Prony’ego
[fest2, dest2 ] = fLPSVD(x,K,dt), % metoda LP-SVD Kumaresana-Tuftsa
[fest1 fest2], [dest1 dest2], % porownanie
% ##########################################
function [fest, dest] = fLP(x,K,dt)
% Metoda LP Prony’ego
% x - analizowany sygnal
% K - przyjeta liczba skladowych (tlumionych kosinusow)
N = length(x); % liczba probek danych
P = 2*K; % rzad predykcji
M = N-P; % maksymalna liczba rownan
FirstCol = x(1:M); LastRow = x(M:M+P-1); % parametry dla macierzy Hankela
Y = hankel( FirstCol, LastRow ); % macierz MxL
y = x(P+1:P+M).’; % wektor Mx1
%a = -pinv(Y)*y; % 1) klasyczne rozwiazanie
a = -Y\y; % 2) optymalizowane rozwiazanie Matlaba
%[U,S,V] = svd(Y,0); S = diag(S); % 3) "nasze" rozwiazanie
%a = -V * (diag(1./S) * (U’*y)); % 3) macierz pseudoodwrotna z SVD
p = log( roots( [1 fliplr(a’)] ) ); % pierwiastki wielomianu a
Om = imag(p); [Om indx] = sort( Om, ’ascend’ ); Om = Om(K+1:2*K); % cz. katowe
D = -real( p(indx(K+1:2*K)) ); % tlumienia
fest = Om/(2*pi*dt); % czestotliwosci obliczone
dest = D/dt; % tlumienie obliczone