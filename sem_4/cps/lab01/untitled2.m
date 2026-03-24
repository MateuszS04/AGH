% Parametry sygnału
A = 230;           % Amplituda [V]
f = 50;            % Częstotliwość [Hz]
T = 0.1;           % Czas trwania [s]

% Częstotliwości próbkowania
fs1 = 10000;       % 10 kHz
fs2 = 500;         % 500 Hz
fs3 = 200;         % 200 Hz

% Generowanie sygnału

t1 = 0:1/fs1:T; 
t2 = 0:1/fs2:T; 
t3 = 0:1/fs3:T; 

s1 = A * sin(2 * pi * f * t1);
s2 = A * sin(2 * pi * f * t2);
s3 = A * sin(2 * pi * f * t3);

% Rysowanie wykresu
figure;
plot(t1, s1, 'b-');          % Pseudo analogowy sygnał
hold on;
plot(t2, s2, 'r-o');         % Próbkowanie 500 Hz
plot(t3, s3, 'k-x');         % Próbkowanie 200 Hz

% Dodatkowe ustawienia wykresu
grid on;
xlabel('Czas [s]');
ylabel('Napięcie [V]');
legend('fs = 10 kHz', 'fs = 500 Hz', 'fs = 200 Hz');
title('Próbkowanie sinusoidy 50 Hz o amplitudzie 230 V');

hold off;