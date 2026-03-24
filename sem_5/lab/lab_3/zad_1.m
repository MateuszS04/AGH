close all
clear all
load('cr_n1.mat')


fs=200e3;
N=length(rxSig);
t=(0:N-1)'/fs;


f=linspace(-fs/2,fs/2,N);
y=fftshift(abs(fft(rxSig)));

figure
plot(f,y)

[~,k]=max(y);
y0=y(k);
yL=y(k-1);
yR=y(k+1);

delta=0.5*(yL-yR)/(yL-2*y0+yR);

N_zp=8*N;
freq_est=f(k)+delta*(fs/N_zp);

fprintf('FFT peak + parabolic interpolation: f_offset = %.3f Hz\n', freq_est);

alpha=0.35;
sps=100;
span=6;

M=50;
cutoff_freq=0.5/M;
order=200;
h=fir1(order,2*cutoff_freq);
s_decimated=downsample(filter(h,1,rxSig),M);
Fs_new=fs/M;
N_new=length(s_decimated);
y_new=fftshift(abs(fft(s_decimated)));

f_new=linspace(-Fs_new/2,Fs_new/2,N_new);
figure;
plot(f_new, abs(y_new));
title(['Widmo po Decymacji, Fs = ', num2str(Fs_new), ' Hz']);
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
grid on;
