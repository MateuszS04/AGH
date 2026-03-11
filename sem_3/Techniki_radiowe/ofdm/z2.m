clear all;
close all;

clear all;
Fs= 1e6; % częstotliwość próbkowania w Hz
prefSize=16;%rozmiar prefiksu wyrażony w próbkach
%TODO 1: przyjmujac że częstotliwośc próbkowania oraz długośc prefiksu cyklicznego nie ulegają zmianie
%narysuj wykres obrazujący czas trwania symbolu OFDM w funkcji liczby podnośnych. Przyjmij że liczba podnośnych stanowi kolejne potęgi dwójki
%rozważ rozmiary transformat od 64 do 4096
scNumValues=2.^(6:12);
symDurations=((scNumValues+prefSize)/Fs)*1000;
figure;
semilogx(scNumValues,symDurations,'-o');

