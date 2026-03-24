clear all; close all;

%% Dane trzech sygnałów sinusoidalnych
f1 = 1001.2; %Hz
f2 = 303.1;
f3 = 2110.4;

fs1 = 8e3;
fs2 = 32e3;
fs3 = 48e3;

t1 = 0:1/fs1:1-1/fs1;
t2 = 0:1/fs2:1-1/fs2;
t3 = 0:1/fs3:1-1/fs3;

%% Tworzenie i plotowanie sygnałów sinusoidalnych
x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);

figure('Name','Fragmenty składowych sygnałow sinusoidalnych');
hold on;
plot(t1,x1,'r');
plot(t2,x2,'b');
plot(t3,x3,'g');
title('Fragmenty składowych sygnałow sinusoidalnych');
legend('1001.2Hz','303.1Hz','2110.4Hz');
xlabel('Czas [s]');
ylabel('Amplituda');
hold off;

xlim([0 1/f3]);

%% Suma trzech sygnalow sinusoidalnych analitycznie
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);

%% upsampling, zw. częstotliwości próbkowania
x1up = upsample(x1,fs3/fs1); % na 48khz wstawianie zer między próbki
fir_interp=fir1(128,fs1/fs3);  % filtr interpolacyjny, wygładza sygnał 
x1_up_filt=conv(x1up,fir_interp,'same');%filtruje usuwając wstawianie zer i przywracając pełne informacje

[P,Q] = rat(fs3/fs2);                   %dobiera najlepiej dopasowany ułamek do stosunku częstotliwości
x2re  = resample(x2,P,Q); 
% 
% x2up = decimate(upsample(x2,3),2);      % x2 z 32khz na 96khz i potem co druga probka ->48khz zawiera filtrację antyaliasingową
x4_upsampling = x1_up_filt(1:length(x3)) + x2re(1:length(x3)) + x3;   %wszystkie doprowadzone do 48kHz i sumowane

%% resampling
x1re  = resample(x1,fs3,fs1);           %x1 z 8khz na 48khz metoda : interoplacja + antyaliasing
x4_resampling = x1re(1:length(x3)) + x2re(1:length(x3)) + x3;   

% soundsc(x4,fs3);
% pause(length(x4)/fs3 +1);
% soundsc(x4_resampling,fs3);
% pause(length(x4_resampling)/fs3 +1);
% soundsc(x4_upsampling,fs3);
% pause(length(x4_upsampling)/fs3 +1);

%% Porownanie sygnałów analitycznego i po upsamplingu
figure('Name','Porownanie sygnałów analitycznego i po upsamplingu');

subplot(2,1,1); hold all;
plot(x4, 'r'); plot(x4_upsampling, 'b');
title('Sygnal analityczny i po upsamplingu');
legend('analityczny','upsampling');

subplot(2,1,1);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');
xlim([0 0.5e4]);

subplot(2,1,2);
plot(abs(fft(x4_upsampling)),'b');
title('Widmo - sygnal po upsamplingu');
xlim([0 0.5e4]);

%% Porownanie sygnałów analitycznego i po resamplingu
figure('Name','Porownanie sygnałów analitycznego i po resamplingu');
subplot(3,1,1);
hold all;
plot(x4, 'r');
plot(x4_resampling, 'b');
title('Sygnal analityczny i po resamplingu');
legend('analityczny','resampling');

subplot(2,1,1);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');
xlim([0 0.5e4]);

subplot(2,1,2);
plot(abs(fft(x4_resampling)),'b');
title('Widmo - sygnal po resamplingu');
xlim([0 0.5e4]);

%% MIKS x1 i x2
[x1wav, fs1w] = audioread('x1.wav');
[x2wav, fs2w] = audioread('x2.wav');
x1wav = x1wav(:,1)';
x2wav = x2wav';
f_wav = 48e3;                                               % resampling do 48kHz

%interpolacja wav1
[P1,Q1] = rat(f_wav/fs1w);
x1_resamp = resample(x1wav, P1,Q1);
vector1 = linspace(1, length(x1wav), 1.5*length(x1wav));    % 1,5*32kHz ->48kHz
x1wav_interp = interp1(x1wav, vector1);

%interpolacja wav2
[P2,Q2] = rat(f_wav/fs2w);
x2_resamp = resample(x2wav, P2,Q2);
vector2 = linspace(1, length(x2wav), 6*length(x2wav));      % 6*8kHz ->48kHz
x2wav_interp = interp1(x2wav, vector2);

miks = x1wav_interp;                                                        % sygnał 1
miks(1:length(x2wav_interp)) = miks(1:length(x2wav_interp)) + x2wav_interp; % sygnał 2 dodany do 1

% sound(miks(1:length(x1wav_interp)), f_wav);

%% Miksowanie plików do formatu CD-Audio
[x1_m, fs1m] = audioread('x1.wav');
[x2_m, fs2m] = audioread('x2.wav');


x1_m = mean(x1_m, 2);
x2_m = mean(x2_m, 2);


fs_target = 44100;
x1r_m = resample(x1_m, fs_target, fs1m);
x2r_m = resample(x2_m, fs_target, fs2m);


len = min(length(x1r_m), length(x2r_m));
x_mix = x1r_m(1:len) + x2r_m(1:len);

% soundsc(x_mix,fs_target)


%% interpolacja liniowa do 48kHz

ts = linspace(0,1,length(t3));

x1_lin = interp1(t1, x1, ts, 'linear', 0);
x2_lin = interp1(t2, x2, ts, 'linear', 0);

x4_linear = x1_lin + x2_lin + x3;
% soundsc(x4_linear,fs3);
%% rekonstrukcja przez splot z sinc

L=7; %liczba próbek sąsiednich 
xhat=zeros(size(ts));

%rekonstrukcja 1 z 8khz na 48 kHz
for idx=1;length(ts)
    t=ts(idx);
    xhat1=0;
    for n=-L:L
        tn=n/fs1;
        idx_n=round(tn*fs1)+1;%indeks próbki w x1
        if idx_n>0 && idx_n <=length(x1)
            sinc_val=sinc((t-tn)*fs1);
            xhat1=xhat1+x1(idx_n)*sinc_val;
        end
    end
    x1_sinc(idx)=xhat1;
end

for idx=1;length(ts)
    t=ts(idx);
    xhat2=0;
    for n=-L:L
        tn=n/fs2;
        idx_n=round(tn*fs2)+1;%indeks próbki w x1
        if idx_n>0 && idx_n <=length(x2)
            sinc_val=sinc((t-tn)*fs2);
            xhat2=xhat2+x2(idx_n)*sinc_val;
        end
    end
    x2_sinc(idx)=xhat2;
end
x4_sinc=x1_sinc +x2_sinc+x3;

% soundsc(x4_sinc,fs3);

  