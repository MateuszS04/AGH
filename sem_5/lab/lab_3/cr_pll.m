%zakladamy ¿e pracujemy z Fs=200000 probek/sekunde
Fs=1e5;
%przyjmijmy:
%czêstotliwoœæ spoczynkow¹ pêtli na 10 kHz
pllFreq=10000;
%pasmo pêtli = 2*pi/100.0
loopBW=2*pi/1000.0;
%obliczamy omega0
omega0=2*pi*pllFreq/Fs;
%ustalamy czêstotliwoœæ generatora na 11 kHz
genFreq=12000;
%generujemy sygna³ testowy
omegaG=2*pi*genFreq;

t=(0:1/Fs:0.1)';
Xin=cos(omegaG*t);
X2=0*(1:500)';
[Xout,err]=realPll(Xin,loopBW,omega0);
plot(err);
title('error')
figure
plot(t(1:1500),Xin(1:1500),'g')
hold on
plot(t(1:1500),Xout(1:1500),'r')