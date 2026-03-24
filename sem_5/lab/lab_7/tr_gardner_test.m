clear all;
close all;
inData=randi(2,10*1024,1)-1; %generujemy strumien losowych bitow
noise=randn(1,1);%+1i*randn(500,1);
modData=pskmod(inData,2) + 0.001 * (randn(10*1024,1)); %modulujemy BPSK
rolloff =0.35; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus
txFilt = upfirdn(modData, rrcFilter, sps, 1);%ksztaltujemy widomo sygnalu w naajniku
phOff=10;
 rxData = upfirdn(txFilt(phOff:end), rrcFilter, 1, sps/2); %skorygowany sygnal przepuszczamy przez filtr kana³owy
 [y,e] = gardner(rxData(256:end),'interpolation','linear','loopBW',2*pi/1000);

 
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
