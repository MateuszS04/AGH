clear all;
close all;
inData=randi(2,10*1024,1)-1; %generujemy strumien losowych bitow
modData=pskmod(inData,2) + 0.001 * (randn(10*1024,1)); %modulujemy BPSK
rolloff =0.35; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus
txFilt = upfirdn(modData, rrcFilter, sps, 1);%ksztaltujemy widomo sygnalu w naajniku
phOff=10; %wprowadzamy fractional delay do testu

 rxData = upfirdn(txFilt(phOff:end), rrcFilter, 1, sps); %skorygowany sygnal przepuszczamy przez filtr kana³owy
 [y,e] = muller(rxData(256:end),'interpolation','Farrow');
 
figure;
subplot(3,1,1);
plot(real(y),'b.');
title('sygna³ wyjœciowy synchronizatora');

subplot(3,1,2);
plot(real(y(100:end)),imag(y(100:end)),'b.');
 axis([-1 1 -1 1])
title('diagram konstelacji');

subplot(3,1,3);
plot(e(1:end-10));
title('OpóŸnienie sygna³u');
