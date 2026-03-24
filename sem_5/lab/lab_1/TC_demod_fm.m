% kwant@agh.edu.pl
%
% v1 11-08-2018: init
%
% simple FM demodulation

clear;
close all;

%% sampling frequency
fs = 2.0e6;

%% read raw file and convert to IQ samples
load('multiplex');

% figure,
% pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

%% select station (need BP filtering)
fc = 450e3;
bw_half=5e3;
bandwidth=[fc-bw_half,fc+bw_half];% select station
h = fir1(2048,bandwidth/(fs/2),'bandpass');        % design BP filter around fc
iq = filter(h, 1, iq);

%% shift fc -> 0 Hz (remodulate to BB)
% figure,
% pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')
t=(0:length(iq)-1)/fs;
iq = iq.*exp(-1j*2*pi*t*fc);

figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

%% demodulate FM
snd = angle(iq(2:end).*conj(iq(1:end-1)));

%% decimate to 44100 (audio)
snd = decimate(snd, round(fs/44100));

%% play sound
soundsc(snd, 44100);