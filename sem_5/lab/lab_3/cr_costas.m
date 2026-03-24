clear all;
close all;
load('cr_n1');

%Fs=2e5;
rolloff =0.35; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=100; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus

rxFilt = upfirdn(rxSig, rrcFilter, 1, sps);%decymujemy sygna³ odebrany pêtla costasa pracuje z szybkoœci¹ równ¹ szybkoœci symbolowej

[y,e] = costasLoopM(rxFilt,2*pi/100,1);
plot(e);
scatterplot(y(1000:end));


