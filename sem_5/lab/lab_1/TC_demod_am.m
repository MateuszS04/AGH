% kwant@agh.edu.pl
%
% v1 11-08-2018: init
%
% simple AM demodulation

clear;
close all;

%% sampling frequency
fs = 2.0e6;

%% read raw file and convert to IQ samples
load('multiplex');

% figure,
% pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

%% select station (need BP filtering)
fc =200e3;  % select station
bandwidth=[195e3,205e3];
h =fir1(2048,bandwidth/(2*fs),'bandpass');         % design BP filter around fc
iq = filter(h, 1, iq);

%% shift fc -> 0 Hz (remodulate to BB)
figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')
t=(0:length(iq)-1)/fs;
iq =iq.* exp(-1j*2*pi*t*fc);

figure,
pwelch( iq(1:1e6), 4096, 2048, [], fs, 'centered')

%% demodulate AM
snd = real(iq);

%% decimate to 44100 (audio)
snd = decimate(snd, round(fs/44100));

%% play sound
soundsc(snd, 44100);
