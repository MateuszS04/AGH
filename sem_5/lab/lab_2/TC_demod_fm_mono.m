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
figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered');

%% select station, shift to BB, Low-pass and decimate to fh
fshift =0.1e6;  % select station, shift offset
t=(0:length(iq)-1)/fs;
iq = iq.*exp(fshift*1j*2*pi*t)';            % shift fshift -> 0 Hz (remodulate to BB)

figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

% LP filter (128 kHz)
BW=128e3;
h = fir1(2048,BW/(fs/2),'low');            
iq = filter(h, 1, iq);
iq = decimate(iq, fs/fh); % decimat to fh=256 kHz

figure,
pwelch( iq, 4096, 2048, [], fh, 'centered')

%% demodulate FM
hybrid = diff(unwrap(angle(iq)));
hybrid=[hybrid;hybrid(end)];

figure,
pwelch( hybrid, 4096, 2048, [], fh)


%% decimate to 32000 (audio)
sndLpR = decimate(hybrid, fh/fa); % decimate to audio frequency

%% pilot
f_p=19e3;
t=(0:length(hybrid)-1)'/fh;
p38 =cos(2*pi*2*f_p*t);

%% decimate to 44100 (audio)
snd = decimate(hybrid, fh/fa); % decimate to audio frequency

%% play sound
soundsc(snd, fa);
