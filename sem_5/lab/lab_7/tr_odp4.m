clear all;
close all;
inData=randi(2,1024,1)-1; %generujemy strumien losowych bitow
noise=randn(1,1);%+1i*randn(500,1);
modData=pskmod(inData,2) + 0.001 * (randn(1024,1)); %modulujemy BPSK
rolloff =0.9; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=64; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus
txFilt = upfirdn(modData, rrcFilter, sps, 1);%ksztaltujemy widomo sygnalu w naajniku
% H = comm.PhaseFrequencyOffset('FrequencyOffset',5,'SampleRate',2e5);
% txFilt=H.step(txFilt);
% scatterplot(txFilt);
% title('Constellation after tx filter');
% pfo = comm.PhaseFrequencyOffset('FrequencyOffset',600,'SampleRate',2e5,'PhaseOffset',20);
% txFilt=step(pfo,txFilt);%a tu wcielamy je w zycie


rxData = upfirdn([noise; txFilt], rrcFilter, 1, 1); %skorygowany sygnal przepuszczamy przez filtr kana³owy
[y,e] = gardnerU(rxData(600:end),sps);


figure;
subplot(2,2,1);
%eyepattern
for i=1:2*sps:length(rxData)-sps
    plot(real(rxData(i:i+sps)));
    hold on;
end
title('Wykres oczkowy (eye pattern)');

subplot(2,2,2);
plot(real(y));
title('sygna³ wyjœciowy synchronizatora');

subplot(2,2,3);
plot(real(y(100:end)),imag(y(100:end)),'b.');
 axis([-1 1 -1 1])
title('diagram konstelacji');
%dlaczego s¹ kreski a nie kropki?
%od czego zale¿y rozmiart kresek?

subplot(2,2,4);
plot(e);
title('OpóŸnienie sygna³u w próbkach');



