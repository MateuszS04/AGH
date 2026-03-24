fs=8000;
time=4;

[x,fs_orginalne]=audioread('mowa.wav');

x_resampled=resample(x,fs,fs_orginalne);
figure;
plot(x_resampled);

%soundsc(x_resampled,fs)
c=dct(x_resampled);

figure
stem(c)

