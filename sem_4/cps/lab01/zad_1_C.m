clear all;
close all;

A=230;
fs=50;
T=1;
dt=1/fs;

figure;
for f =0:5:300
    t=0:dt:T;
    x1=A*sin(2*pi*t*f);
    plot(t,x1);
    title(sprintf('Obieg pętli: %d, Częstotliwość: %d Hz', f/5 + 1, f));
    xlabel('czas [s]')
    pause(0.1);
end

figure;
hold on;
plot(t, A * sin(2 * pi * 5 * t),'r-o');
plot(t, A * sin(2 * pi * 105 * t),'g-o');
plot(t, A * sin(2 * pi * 205 * t),'b-');
hold off;
title('Sinusoidy 5 Hz, 105 Hz, 205 Hz');
    figure;
    hold on;
plot(t, A * sin(2 * pi * 95 * t),'r-o');
plot(t, A * sin(2 * pi * 195 * t),'b-');
plot(t, A * sin(2 * pi * 295 * t),'g-o');
hold off;
title('Sinusoidy 95 Hz, 195 Hz, 295 Hz');
pause;

figure;

for f = 0:5:300
    x2 = A * cos(2 * pi * f * t);
    plot(t, x2);
    title(sprintf('Obieg pętli: %d, Częstotliwość: %d Hz (cos)', f/5 + 1, f));
    xlabel('Czas [s]');
    pause(0.1);
end

figure;
hold on;
plot(t, A * cos(2 * pi * 5 * t));
plot(t, A * cos(2 * pi * 105 * t));
plot(t, A * cos(2 * pi * 205 * t));
hold off;
title('Kosinusoidy 5 Hz, 105 Hz, 205 Hz');

figure;
hold on;
plot(t, A * cos(2 * pi * 95 * t));
plot(t, A * cos(2 * pi * 195 * t));
plot(t, A * cos(2 * pi * 295 * t));
hold off;
title('Kosinusoidy 95 Hz, 195 Hz, 295 Hz');

figure;
hold on;
plot(t, A * cos(2 * pi * 95 * t),'r-o');
plot(t, A * cos(2 * pi * 105 * t));
hold off;
title('Kosinusoidy 95 Hz i 105 Hz');

