close all
clear all
load('cr_n1.mat')
%QPSK 100 próbek na symbol
%filtr kanałowy 0,35

fs=2e5;

rx=rxSig.^4;% usunięciem modulacji
N=length(rx);


y=fftshift(abs(fft(rx)));

f=linspace(-fs/2,fs/2,N);%wektor częstotliwości odpowiadający punktom w transformaty fouriera

[~,idx]=max(y);% szukamy indeksu w widmie w którym apmlituda jest maksymalna
f_est=f(idx); % 
f_est_fin=f_est/4;% ponieważ podnosimy na początku do czwartej aby usunąć modulację 
% to błąd przesunięcia 
% też jest pomnożony przez 4 więc aby uzyskać poprostu przesunięcie trzeba podzielić przez 4

t=(0:N-1)'/fs;
rxCorr=rxSig.*exp(-1j*2*pi*f_est_fin*t);% korekcja w dziedzinie czasu powoduje przesunięcie widma sygnału do 
% z powrotem o błąd delta f i środek widma jest na 0Hz

% rxCorr=shift_freq(rxSig,fs);

figure
scatterplot(rxCorr(1:100:end)) % Wybór próbek co symbol bo jak wykreślimy wszystkie próbki to nic z tego nie wyjdzie 
% bo QPSK jest zdefiniowane tylko w określonym punkcie czasowym
% title(sprintf('Po korekcji (Delta f = %.2f Hz)', f_est_fin))

% szacowanie rozmiaru transformaty dla f=10,5,1 Hz polega na tym że:
%N_fft=Fs/f