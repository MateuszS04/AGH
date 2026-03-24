clear all;
close all;

inData=randi(2,1024,1)-1; %generujemy strumien losowych bitow
inData=[1;0;1;0;1;1;1;inData];
modData=2*inData-1;
noise=randn(1,1);%+1i*randn(500,1);
rolloff =0.29; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus
txFilt = upfirdn(modData, rrcFilter, sps, 1);%ksztaltujemy widomo sygnalu w naajniku
x=1;
rxData = upfirdn(txFilt(x:end), rrcFilter, 1, 1); %skorygowany sygnal przepuszczamy przez filtr kana³owy
plot(rxData(900:1940));
grid on
title('piêæ pierwszych symboli')

figure;
title('eye pattern');
for i=900:2*sps:length(rxData)-sps
    plot(real(rxData(i+sps/2:i+1.5*sps)));
    hold on;
end


