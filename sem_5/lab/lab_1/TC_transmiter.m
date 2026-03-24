% kwant@agh.edu.pl
%
% v1 05-08-2018: init
% v2 06-08-2018: +AM
% v3 07-08-2018: +FM
% v4 10-08-2018: +AM rand
%
% simple AM/FM signals on ISM band

clear;
close all;

f0 = 0;         % AM const at 0Hz
f1 = 25e3;      % AM const at 25 kHz
f2 = 50e3;      % AM cos
f3 = 100e3;     % AM exp
f4 = 150e3;     % AM rand
f5 = 200e3;     % AM DSB-C speech 
f6 = 250e3;     % AM DSB-SC speech 
f7 = 300e3;     % AM SSB-SC speech 
f8 = 350e3;     % FM cos
f9 = 400e3;     % FM exp
f10 = 450e3;     % FM speech

time = 5;       % X seconds
fs = 2e6;       % sampling frequency
fc = 435e6;     % carier frequency

t = linspace(0, time-1/fs, fs*time);    % time domain
[speech_raw, spfs] = audioread('male_voice.wav');
speech_raw = speech_raw(1:spfs*time)';
speech = resample(speech_raw, fs, spfs);

%% AM modulated with const at 0Hz
A0 = 1;
x0 = cos(2*pi*f0*t) .* A0;

%% AM modulated with const at 25 kHz
A1 = 0.1;
x1 = cos(2*pi*f1*t) .* A1;

%% AM modulated with cos
fam = 5e3;
carrier = exp(1j*2*pi*f2*t);
x2 =  carrier .* cos(2*pi*fam*t);

%% AM modulated with rand
A3 = 10;
carrier = exp(1j*2*pi*f3*t);
sig = randn(size(real(carrier)));       % create random signal
bw = 10e3;                                       % bandwidth in Hz
h = fir1(2048, 1/fs*bw);                      
sig = filter(h, 1, sig);                        % random signal s
x3 =  A3 * carrier .* sig;

%% AM modulated with exp
fam = 20e3;
carrier = exp(1j*2*pi*f4*t);
x4 =  carrier .* exp(1j*2*pi*fam*t);

%% AM modulated with speech - DSB-C
carrier = exp(1j*2*pi*f5*t);
x5 =  carrier .* (1+speech);

%% AM modulated with speech - DSB-SC
A6 = 10;
carrier = exp(1j*2*pi*f6*t);
x6 =  A6 * carrier .* speech;

%% AM modulated with speech - SSB-SC
A7 = 10;
speech_hilbert = hilbert(speech);
x7 = A7*0.5*exp(1j*2*pi*f7*t).*speech_hilbert;
% carr_cos = cos(2*pi*f7*t);        % alternative approach
% carr_sin = sin(2*pi*f7*t);
% x7 = 0.5*carr_cos.*real(speech_hilbert) + 0.5*carr_sin.*imag(speech_hilbert);

%% FM modulated with cos
carrier = exp(1j*2*pi*f8*t);
ffm = 1500;                                 % frequency of harmonic == signal data
signal = cos(2*pi*ffm*t);              % data (signal)
kf = 10000;                                  % bandwidth of modulation (bandwidth)
fi = kf*cumsum(signal);
x8 = carrier.*cos(2*pi*(f8*t+fi)/fs);

%% FM modulated with exp
carrier = exp(1j*2*pi*f9*t);
ffm = 5000;                                 % frequency of harmonic == signal data
signal = cos(2*pi*ffm*t);              % data (signal)
kf = 10000;                                  % bandwidth of modulation (bandwidth)
fi = kf*cumsum(signal);
x9 = carrier.*exp(1j*2*pi*fi/fs);

%% FM modulated with speech
carrier = exp(1j*2*pi*f10*t);
kf = 20000;                                  % bandwidth of modulation (bandwidth)
fi = kf*cumsum(speech);             % assume speech is in range [-1...1]
x10 = carrier.*exp(1j*2*pi*fi/fs);

%% transmission
iq = x3 + x4 + x5 + x6 + x7 + x8 + x9+x10;
% iq = x0;

iq = iq./(max(abs(iq)) *1.2);       % prevent clipping: fit ampliude in [-0.8 ... 0.8]

% figure,
% plot( real(iq_linear), 'b'), hold on;
% plot( imag(iq_linear), 'r'), hold off

 figure,
 pwelch( iq, [], [],[], fs, 'twosided')
 % return;

save('multiplex','iq');      