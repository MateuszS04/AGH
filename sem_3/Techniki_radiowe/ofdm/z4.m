clear all
close all
Fs=1e6;
prefSize=16;


%TODO 1:
%liczba podnośnych z zakresu 128-4096 (jako rozmiar transformaty przyjmij kolejne potęgi 2: (128,256,512,1024,2048,4096),
fftSize=[128,256,1024,2048,4096];
paprQpsk=zeros(length(fftSize),1);
papr64Qam=zeros(length(fftSize),1);

%TODO 2:
%napisz strukturę pętli iterującą po wektorze fftSize
%TODO 3:
%w wewnętrznej pętli 
% Każdy punkt na wykresie wyznacz jako średnią ze 100 eksperymentów, z których każdy to 
% wygenerowanie 10 symboli OFDM i wyznaczenie współczynnika szczytu sygnału. 
% wyniki zapisz w zmiennych paprQpsk i papr64Qam
exp=100;
symNum=10;

for i=1:length(fftSize)
    paprValuesQpsk=zeros(exp,1);
    paprValuesQam=zeros(exp,1);

    for j=1:exp
        tdTxSigQpsk=ofdmTx(symNum,prefSize,fftSize(i),4,10,0);
        paprValuseQpsk(j)=max(abs(tdTxSigQpsk).^2)/mean(abs(tdTxSigQpsk).^2);

        tdTxSigQam=ofdmTx(symNum,prefSize,fftSize(i),64,10,0);
        paprValuesQam(j)=max(abs(tdTxSigQam).^2)/mean(abs(tdTxSigQam).^2);
    end

    paprQpsk(i)=mean(paprValuesQpsk);
    papr64Qam(i)=mean(paprValuesQam);
end

figure;
plot(fftSize,paprQpsk)
hold on;
plot(fftSize,papr64Qam)

plot(fftSize,paprQpsk,'g');
hold on;
grid on;
plot(fftSize,papr64Qam,'r');
xlim([fftSize(1) fftSize(end)]);