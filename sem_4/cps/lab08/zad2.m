 clear all; close all;

%% Filtr Hilberta
% Generowanie teoretycznej odpowiedzi impulsowej, filtr Hilberta
fs = 400e3;                         % czestotliwosc probkowania
fc = 100e3;                         % czestotliwosc nosna
M  = 1024;                          % polowa dlugosci filtra
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;     % połowa odpowiedzi impulsowej
h  = [-h(M:-1:1) 0 h(1:M)];         

% Wymnażanie przez okno Blackmana
w  = blackman(N); 
w  = w';            
hw = h.*w;  

%% Wczytwanie sygnału
[x1,fs1] = audioread('mowa8000.wav');
x1 = x1';
x2 = fliplr(x1);                    % druga stacja to mowa8000 od tyłu

%% Parametry sygnalow radiowych
fs  = 400e3;                        % czestotliwosc probkowania sygnalu radiowego
fc1 = 100e3;                        % czestotliwosc nosna 1 stacji
fc2 = 110e3;                        % czestotliwosc nosna 2 stacji
dA  = 0.25;                         % glebokosc modulacji obu stacji

%% Resampling w celu uzyskania poprawnej modulacji AM (dopasowanie częstotliwości do pliku)
xr1 = resample(x1, fs, fs1);
xr2 = resample(x2, fs, fs1);  

xh1 = conv(xr1,hw); %przepuszczenie przez filtr, conv-splot sygnału i filtra
xh2 = conv(xr2,hw);

xh1 = xh1(M+1:length(xr1)+M);%usuwamy efekty brzegowe, wybieramy środkowy fragment wynikowego sygnału
xh2 = xh2(M+1:length(xr2)+M);

t1 = length(x1)/fs1;
t  = 0:1/fs:t1-1/fs;

%% Generowanie sygnalow radiowych
%DSB-C
Ydsb_c_a = (1+xr1).*cos(2*pi*fc1*t); %stacja 1
Ydsb_c_b = (1+xr2).*cos(2*pi*fc2*t); %stacja 2
Ydsb_c   = dA*(Ydsb_c_a + Ydsb_c_b);

%DSB-SC
Ydsb_sc_a = xr1.*(cos(2*pi*fc1*t));
Ydsb_sc_b = xr2.*(cos(2*pi*fc2*t));
Ydsb_sc   = dA*(Ydsb_sc_a + Ydsb_sc_b);

%SSB-SC (+) wstega po lewej
Yssb_sc1_a = 0.5*xr1.*cos(2*pi*fc1*t) + 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc1_b = 0.5*xr2.*cos(2*pi*fc2*t) + 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc1   = dA*(Yssb_sc1_a + Yssb_sc1_b);

%SSB-SC (-) wstega po prawej
Yssb_sc2_a = 0.5*xr1.*cos(2*pi*fc1*t) - 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc2_b = 0.5*xr2.*cos(2*pi*fc2*t) - 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc2   = dA*(Yssb_sc2_a + Yssb_sc2_b);

%transformaty powyzszych sygnalow AM
HYdsb_c   = fft(Ydsb_c);
HYdsb_sc  = fft(Ydsb_sc);
HYssb_sc1 = fft(Yssb_sc1);
HYssb_sc2 = fft(Yssb_sc2);

%% Wykresy widm - porównanie typów modulacji AM
f = (0:length(HYdsb_c)-1)/length(HYdsb_c)*fs;

figure;
subplot(1,2,1);
plot(f, abs(HYdsb_c));
title('fft DSB-C');
xlim([90e3 120e3]);

subplot(1,2,2);
plot(f, abs(HYdsb_sc));
title('fft DSB-SC');
xlim([90e3 120e3]);

figure;
subplot(1,2,1);
plot(f, abs(HYssb_sc1));
title('fft SSB-SC (+)');
xlim([90e3 120e3]);

subplot(1,2,2);
plot(f, abs(HYssb_sc2));
title('fft SSB-SC (-)');
xlim([90e3 120e3]);

%% Demodulacja 3 transmisji
% dla dsb_c
t=0:1/fs:length(Ydsb_c)/fs -1/fs;
z1=Ydsb_c.*cos(2*pi*fc1*t);
z2=Ydsb_c.*cos(2*pi*fc2*t);

zd1=conv(z1,hw);
zd2=conv(z2,hw);

zd1=zd1(M+1:end-M);
zd2=zd2(M+1:end-M);

yd1=resample(zd1,fs1,fs);
yd2=resample(zd2,fs1,fs);

yd2=fliplr(yd2);

%dla dsb_sc


z3=Ydsb_sc.*cos(2*pi*fc1*t);
z4=Ydsb_sc.*cos(2*pi*fc2*t);

zd3=conv(z1,hw);
zd4=conv(z2,hw);

zd3=zd3(M+1:end-M);
zd4=zd4(M+1:end-M);

yd3=resample(zd3,fs1,fs);
yd4=resample(zd4,fs1,fs);

yd4=fliplr(yd4);

%ssb_sc dla górnej wstęgi

z5=Yssb_sc1.*cos(2*pi*fc1*t)+ hilbert(Yssb_sc1).* sin(2*pi*fc1*t);
z6=Yssb_sc1.*cos(2*pi*fc2*t)+ hilbert(Yssb_sc1).* sin(2*pi*fc2*t);

zd5=conv(z5,hw);
zd6=conv(z6,hw);

zd5=zd5(M+1:end-M);
zd6=zd6(M+1:end-M);

yd5=resample(zd5,fs1,fs);
yd6=resample(zd6,fs1,fs);
yd6=fliplr(yd6);

yd5 = real(yd5);
yd6 = real(yd6);

% soundsc(yd1, fs1); pause(length(yd1)/fs1 + 1);
% soundsc(yd2, fs1); pause(length(yd2)/fs1 + 1);
% soundsc(yd3, fs1); pause(length(yd3)/fs1 + 1);
% soundsc(yd4, fs1); pause(length(yd4)/fs1 + 1);
% soundsc(yd5, fs1); pause(length(yd5)/fs1 + 1);
% soundsc(yd6, fs1);
% 
% figure;
% subplot(3,2,1); plot(yd1); title('DSB-C fc1');
% subplot(3,2,2); plot(yd2); title('DSB-C fc2');
% subplot(3,2,3); plot(yd3); title('DSB-SC fc1');
% subplot(3,2,4); plot(yd4); title('DSB-SC fc2');
% subplot(3,2,5); plot(yd5); title('SSB-SC fc1');
% subplot(3,2,6); plot(yd6); title('SSB-SC fc2');

%% Umieszczenie dwóch stacji na jednej częstotliwości za pomocą modulacji ssb-sc

M = 8192;  

fc_2=100e3;%nowa nośna wspólna dla obu stacji

Yssb_r=0.5*xr1.*cos(2*pi*fc*t)+0.5*xh1.*sin(2*pi*fc*t);

Yssb_l=0.5*xr2.*cos(2*pi*fc*t)-0.5*xh2.*sin(2*pi*fc*t);
% 
Yssb_sum=Yssb_r+Yssb_l;
% Yssb_sum=Yssb_r;

z1 = Yssb_sum .* cos(2*pi*fc*t);
zd1 = conv(z1, hw); 
zd1 = zd1(M+1:end-M);
yd1 = resample(zd1, fs1, fs);

% Dolna wstęga (stacja 2)
z2 = Yssb_sum .* cos(2*pi*fc*t);
zd2 = conv(z2, hw); 
zd2 = zd2(M+1:end-M);
yd2 = resample(zd2, fs1, fs);
yd2 = fliplr(yd2);
 
% soundsc(yd1, fs1); 
% pause(length(yd1)/fs1 + 1);
% soundsc(yd2, fs1);


% Parametry FFT
Nfft = 2^14; % lub większe w zależności od potrzeb
f = linspace(-fs/2, fs/2, Nfft);

% Widmo sygnału Yssb_sum (sygnał zsumowany)
Y = fftshift(abs(fft(Yssb_sum, Nfft)));
figure;
plot(f/1e3, Y);
title('Widmo sygnału Yssb\_sum');
xlabel('Częstotliwość [kHz]');
ylabel('Amplituda');
grid on;

% Widmo po demodulacji (przed filtrowaniem)
Z1 = fftshift(abs(fft(z1, Nfft)));
figure;
plot(f/1e3, Z1);
title('Widmo z1 (po demodulacji, przed filtrem)');
xlabel('Częstotliwość [kHz]');
ylabel('Amplituda');
grid on;

% Widmo po filtracji
ZD1 = fftshift(abs(fft(zd1, Nfft)));
figure;
plot(f/1e3, ZD1);
title('Widmo zd1 (po filtracji)');
xlabel('Częstotliwość [kHz]');
ylabel('Amplituda');
grid on;

% Widmo końcowego sygnału yd1 (po resamplingu)
YD1 = fftshift(abs(fft(yd1, Nfft)));
f_yd1 = linspace(-fs1/2, fs1/2, Nfft);
figure;
plot(f_yd1/1e3, YD1);
title('Widmo yd1 (po resamplingu)');
xlabel('Częstotliwość [kHz]');
ylabel('Amplituda');
grid on;