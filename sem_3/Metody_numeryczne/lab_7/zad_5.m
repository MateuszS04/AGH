clear all; close all;


K = 10; % zwiększenie k dla większego upodobnienia się do filtra idealnego
w = 0 : pi/100 : pi;

% Define the differentiator filter weights
d1 = 1/12 * [-1 8 0 -8 1];%klasyczny filtr różniczkujący używający stałych wag do przybliżnia pierwszej pochodnje
d2 = firls(K-1, [0 0.5 0.7 1], [0 0.5*pi 0 0], 'differentiator');%filtr różniczkujący używający metody najmniejszych kwadratów

d3 = firpm(K-1, [0 0.5 0.7 1], [0 0.5*pi 0 0], 'differentiator');%filtr z metodą aproksymacji minimaksowej

% rysuje charakterystyki częstotliwości filtrów  oraz pokazuje jak bardzo
% kązdy z nich aproksymuje idealną funkcję pochodną
figure;
plot(0:0.01:0.5, 0:0.01:0.5, 'k.', ...
     w/pi, abs(freqz(d1, 1, w))/pi, 'b-', ...
     w/pi, abs(freqz(d2, 1, w))/pi, 'r--', ...
     w/pi, abs(freqz(d3, 1, w))/pi, 'm-.');
xlabel('Normalized Frequency (f/fnorm)');
title('|D(fnorm)| - Frequency Response of Differentiator Filters');
grid on;
legend('Ideal', 'd1', 'd2 - LS', 'd3 - Min-Max');


%filtry dso sygnału sinusoidalnego
fs = 1000; % Sampling frequency
t = 0:1/fs:1-1/fs; % wektor czasowy

frequencies = [5, 50, 100, 200]; % różne częstotliwości do testowania 
figure;
for f = frequencies
        %generujemy falę sinusową
    x = sin(2 * pi * f * t);
    
    % Apply filters to the sinusoidal input
    y1 = filter(d1, 1, x);
    y2 = filter(d2, 1, x);
    y3 = filter(d3, 1, x);
    

    subplot(length(frequencies), 1, find(frequencies == f));
    plot(t, x, 'k', t, y1, 'b', t, y2, 'r', t, y3, 'm');
    title(['Input Sinusoid at f = ', num2str(f), ' Hz']);
    legend('Input', 'd1', 'd2 - LS', 'd3 - Min-Max');
    xlabel('Time (s)');
    ylabel('Amplitude');
end
%tak sinus staje się cosinusem bo sygnał sinusoidalny jest przesunięty w
%wfazie o pi/2 i amplituda sygnału wynikowego rośnie liniowo wraz z
%wzrostem częstotliwości