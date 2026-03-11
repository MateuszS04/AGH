clear all;
close all;

clear all;
Fs= 1e6; % częstotliwość próbkowania w Hz
fftSize=1024;%rozmiar prefiksu wyrażony w próbkach
%TODO 1: Sporządź wykres wyrażonej w Mbit/s szybkości transmisji sygnału OFDM w funkcji długości prefiksu cyklicznego.
%		 Przyjmij, ze częstotliwość próbkowania w nadajniku oraz rozmiar fft pozostaje bez zmian.
%		 Długość prefiksu cyklicznego zmienia się od 1 do 64 próbek 
cpLengths=1:64;
bitRate=(log2(64)*Fs)./(fftSize+cpLengths)/1e6;
figure;
plot(cpLengths,bitRate,'-o');