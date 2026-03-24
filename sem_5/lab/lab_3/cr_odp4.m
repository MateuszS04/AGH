clear all;
close all;
load('cr_n1');

Fs=2e5;
rolloff =0.35; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=100; % liczba probek na symbol

rxFilt = rxSig .* rxSig; %przepuszczemy sygna³ przez element nieliniowy
rxFilt = rxFilt .* rxFilt; %w przypadku qpsk podnosimy do 4 potêgi

[y,e] = bbpll(rxFilt,2*pi/100,4);
plot(e);


rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus

rxFilt = upfirdn(rxSig.*y, rrcFilter, 1, sps);%decymujemy sygna³ odebrany
scatterplot(rxFilt(500:end));


