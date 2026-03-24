function [y] = shift_freq(x,Fs,N_fft)
%x-> nasz sygnał
%Fs-> częstotliwość próbkowania
%N_fft->rozmiar transformaty
%y-sygnał wyjściowy przesunięty
if nargin<3
    N_fft=length(x);
end


x4=x.^4; % usuwanie modulacji

f=linspace(-Fs/2,Fs/2,N_fft);
x_shift=fftshift(abs(fft(x4,N_fft)));
[~,idx]=max(x_shift);
f_est=f(idx);
f_est_fin=f_est/4;

N=length(x);
t=(0:N-1)'/Fs;
y=x.*exp(-1j*2*pi*f_est_fin*t);
end