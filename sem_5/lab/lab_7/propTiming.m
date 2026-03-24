clear all;
close all;

rolloff =0.35; %wspolczynnik poszerzenia pasma
span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
rrcFilter = rcosdesign(rolloff, span, sps);%tworzymy filtr typu podniesiony cosinus
j=1;
k=1;
maxEbNo=10;
		for x=1:16:sps/2
            for EbNo=0:1:maxEbNo
               numErr=0;
               numBits=0;
                berVec = zeros(3,1); % Updated BER values
                berCalc = comm.ErrorRate('ReceiveDelay',8); 
					while numErr < 200 && numBits < 1e8
                        berCalc.reset();
						inData=randi(2,1024,1)-1; %generujemy strumien losowych bitow
						modData=pskmod(inData,2); %modulujemy BPSK
						txFilt = upfirdn(modData, rrcFilter, sps, 1);%ksztaltujemy widomo sygnalu w naajniku
						%w naszym przyk³adzie x - to nic innego jak opoznienie miedzy nadajnikiem a odbiornikiem - tutaj o u³amek symbolu
						%dla x=1 mamy synchronizacje czasu dla pozosta³ych ju¿ nie
						rxData = upfirdn(txFilt(x:end), rrcFilter, 1, sps); %opozniamy sygnal i przepuszczamy przez filtr kana³owy		
						Noise=sqrt((1/1.35)*10^(-EbNo/10.0))*randn(length(rxData),1);
						%dekodujemy
						outData=pskdemod(rxData+Noise,2);
						%liczymy bledy
                        berVec=berCalc.step(inData,outData(1:1024));
                        numBits=numBits+berVec(3);
                        numErr=numErr+berVec(2);
                    end
                    Ber(j,k)=numErr/numBits;
                    j=j+1;
            end
            legTab{k}=sprintf('offset %0.2g symbol',x/sps);
            k=k+1;
            j=1;
        end
EbNo=0:maxEbNo;
    for p=1:4
        semilogy(EbNo,Ber(:,p));
        hold on;
    end
    legend(legTab);
    grid on;




