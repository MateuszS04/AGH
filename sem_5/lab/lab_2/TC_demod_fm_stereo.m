% kwant@agh.edu.pl
%
% v1 15-11-2018:
%
% radio FM demodulation

clear;
close all;

%% sampling frequency, carrier frequency, hybrid frequency, audio frequency
fc = 102e6; % carrier
fs = 2.048e6; % sampling 
fh = 256e3; % hybrid
fa = 32e3; % audio
numSamples = fs*2;  % 2 seconds

load('fm_fo-104M_fs-2M48.mat');
%load('stereoTest');%alternatywna ścieżka podczas debugowania

% figure,
% pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered');

%% select station, shift to BB, Low-pass and decimate to fh
fshift =0.1e6;                      % select station, shift offset
t=(0:length(iq)-1)/fs;
iq =iq.*exp(1j*2*pi*fshift*t)';            % shift fshift -> 0 Hz (remodulate to BB)

figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

% LP filter (128 kHz)
BW=128e3;
h =fir1(2048,BW/(fs/2),'low');            
iq = filter(h, 1, iq);
iq = decimate(iq, fs/fh); % decimat to fh=256 kHz
% 
% figure,
% pwelch( iq, 4096, 2048, [], fh, 'centered')

%% demodulate FM
hybrid =diff(unwrap(angle(iq)));
hybrid=[hybrid;hybrid(end)];
%load('mpx');%alternatywna ścieżka podczas debugowania
%load('pil');%alternatywna ścieżka podczas debugowania


% figure,
% pwelch( hybrid, 4096, 2048, [], fh)

%% decimate to 32000 (audio)
sndLpR = decimate(hybrid, fh/fa); % decimate to audio frequency

%% pilot
f_p=19e3;
Bw_p=500;
f_low=(f_p-Bw_p)/(fh/2);
f_high=(f_p+Bw_p)/(fh/2);
[b_bp,a_bp]=fir1(1024,[f_low,f_high],'bandpass');
pilot_filt=filtfilt(b_bp,a_bp,hybrid);
% 
figure;
pwelch(pilot_filt,4096,2048,[],fh)

pilot_38=pilot_filt.^2;
figure;
pwelch(pilot_38,4096,2048,[],fh)

%% PLL
mi1=0.1;
mi2=50;
vco_freq=18.8e3;
phase=0;
N=length(pilot_filt);
vco_out=zeros(N,1);
error_sig=zeros(N,1);
integrator=0;

for n=1:N
    vco_out(n)=sin(phase);
    err=pilot_filt(n)*vco_out(n);

    integrator=integrator*mi2*err/fh;
    control=mi1*err+integrator;

    vco_freq_inst=vco_freq+control*1e3;
    phase=phase+2*pi*vco_freq_inst/fh;
    error_sig(n)=err;
end

pilot_38_2=2*vco_out.^2-1;
figure;
pwelch(pilot_38_2,4096,2048,[],fh)
Lmr_remodulated_PLL = hybrid.*pilot_38_2;
Bw_PLL=15e3;
[b_lp,a_lp] = fir1(2048,Bw_PLL/(fh/2),'low');    

Lmr_remodulated_filt_PLL=filtfilt(b_lp,a_lp,Lmr_remodulated_PLL);
sndLmR_PLL = decimate(Lmr_remodulated_filt_PLL, fh/fa);
sndL_PLL = 0.5*(sndLpR+sndLmR_PLL);
sndR_PLL = 0.5*(sndLpR-sndLmR_PLL);

%% remodulate L-R to BB
Lmr_remodulated = hybrid.*pilot_38;
Bw=15e3;
[b_lp,a_lp] = fir1(2048,Bw/(fh/2),'low');    

Lmr_remodulated_filt=filtfilt(b_lp,a_lp,Lmr_remodulated);



% figure,
% title('pilot')
% pwelch( Lmr_remodulated_filt, 4096, 2048, [], fh)

%% LmR reconstruction
sndLmR = decimate(Lmr_remodulated_filt, fh/fa);

%% stereo reconstruction
sndL = 0.5*(sndLpR+sndLmR);
sndR = 0.5*(sndLpR-sndLmR);

% figure,
% t = (0:length(sndL)-1)/fa;
% plot( t, sndL, 'r', t, sndR,'b' );
%% figures
sndL = sndL / max(abs(sndL));
sndR = sndR / max(abs(sndR));
sndL_PLL = sndL_PLL / max(abs(sndL_PLL));
sndR_PLL = sndR_PLL / max(abs(sndR_PLL));

% Pomiar separacji kanałów (po ustabilizowaniu PLL)
start = round(0.2*fa);  % pomijamy początkowe 0.2s dla PLL
sep_ideal = 20*log10(rms(sndL(start:end)) / rms(sndR(start:end)));
sep_PLL   = 20*log10(rms(sndL_PLL(start:end)) / rms(sndR_PLL(start:end)));

fprintf('\n=== PORÓWNANIE SEPARACJI KANAŁÓW ===\n');
fprintf('Idealny pilot: %.2f dB\n', sep_ideal);
fprintf('PLL pilot:     %.2f dB\n', sep_PLL);

% Oś czasu
t_audio = (0:length(sndL)-1)/fa;

% --- Wykres kanałów L ---
figure;
subplot(2,1,1);
plot(t_audio, sndL, 'r', 'LineWidth', 1);
hold on;
plot(t_audio, sndL_PLL, 'b--', 'LineWidth', 1);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Kanał lewy (L): idealny vs PLL');
legend('Idealny', 'PLL');
grid on;

% --- Wykres kanałów R ---
subplot(2,1,2);
plot(t_audio, sndR, 'r', 'LineWidth', 1);
hold on;
plot(t_audio, sndR_PLL, 'b--', 'LineWidth', 1);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Kanał prawy (R): idealny vs PLL');
legend('Idealny', 'PLL');
grid on;

% --- Porównanie separacji kanałów (bar plot) ---
figure;
bar([sep_ideal sep_PLL]);
set(gca, 'XTickLabel', {'Idealny', 'PLL'});
ylabel('Separacja kanałów [dB]');
title('Porównanie separacji stereo – idealny vs PLL');
grid on;


%% play sound
soundsc([sndL, sndR], fa);
