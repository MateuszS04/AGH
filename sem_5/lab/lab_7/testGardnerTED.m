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

    for x=1:sps
%gardner TED
         rxData = upfirdn(txFilt(x:end), rrcFilter, 1, sps/2); %skorygowany sygnal przepuszczamy przez filtr kana³owy
         rxData=real(rxData);
         rxData=rxData./max(rxData);
         m1=rxData(3:end);
         mSr=rxData(2:end-1);
         m3=rxData(1:end-2);
         TED=(m3-m1).*mSr;
         sred=reshape(TED(1:2050),2,[])';
         det(x)=mean(sred(:,1));
    end
plot(det)






