clc; clear; close all;

% Parametry
N = 100;                % Liczba próbek
fs = 1000;             % Częstotliwość próbkowania [Hz]
t = (0:N-1)/fs;        % Oś czasu

% Parametry składowych sygnału
f1 = 50; A1 = 50;
f2 = 100; A2 = 100;
f3 = 150; A3 = 150;

% Generacja sygnału
x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);

% Macierze DCT i IDCT
A = dct(eye(N));       % Macierz DCT
S = idct(eye(N));      % Macierz IDCT

% Wyświetlanie wierszy macierzy A i kolumn macierzy S
figure;
for i = 1:N
    plot(A(i, :), 'b'); hold on;
    plot(S(:, i), 'r'); hold off;
    title(['Wiersz ', num2str(i), ' macierzy A i kolumna ', num2str(i), ' macierzy S']);
    pause(0.1);
end

% Analiza sygnału
y = A * x(:);          % Transformata DCT

% Skalowanie osi częstotliwości
f = (0:N-1) * fs / (2 * N);

% Wykres transformaty DCT
figure;
stem(f, abs(y), 'b');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');
title('Współczynniki DCT sygnału x');

% Perfekcyjna rekonstrukcja sygnału
xr = S * y;
disp(['Rekonstrukcja poprawna: ', num2str(all(abs(xr - x(:)) < 1e-10))]);

%% Zmiana częstotliwości f2 = 105 Hz i analiza
f2 = 105;
x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);
y = A * x(:);

figure;
stem(f, abs(y), 'r');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');
title('Współczynniki DCT dla f2=105 Hz');
xr = S * y;
disp(['Rekonstrukcja poprawna (dla f2=105 Hz): ', num2str(all(abs(xr - x(:)) < 1e-10))]);

%% Przesunięcie wszystkich częstotliwości o 2.5 Hz i analiza
f1 = f1 + 2.5;
f2 = f2 + 2.5;
f3 = f3 + 2.5;
x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);
y = A * x(:);

figure;
stem(f, abs(y), 'm');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');
title('Współczynniki DCT po przesunięciu o 2.5 Hz');
