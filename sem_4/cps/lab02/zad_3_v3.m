% Dane wejściowe
N = 100; % Liczba próbek sygnału
fs = 1000; % Częstotliwość próbkowania [Hz]
t = (0:N-1) / fs; % Wektor czasu
tolerance = 1e-10;

% Parametry sinusoid
freq = [50, 105, 150]; % Częstotliwości [Hz]
ampli = [50, 100, 150]; % Amplitudy
freq = freq + 2.5;

% Inicjalizacja sygnału x
x = zeros(1, N);

% Generowanie sygnału x jako suma sinusoid
for i = 1:3
    x = x + ampli(i) * sin(2 * pi * freq(i) * t);
end

% Budowanie macierzy DCT
n = 0:N-1; % Wektor indeksów czasowych
A = zeros(N, N); % Inicjalizacja macierzy transformaty
m = n;

A = sqrt(2/N)*cos(pi/N*(m+0.5)'*(n+0.5));

% Budowanie macierzy IDCT jako transpozycji macierzy DCT
S = A';

%Wyświetlanie kolejnych wierszy macierzy A i kolumn macierzy S
figure;
for i = 1:N
    subplot(2, 1, 1);
    plot(A(i, :), 'r');
    title(['Wiersz macierzy A: ', num2str(i)]);
    ylim([-1, 1]); % Ustawienie zakresu osi y
    subplot(2, 1, 2);
    plot(S(:, i), 'b');
    title(['Kolumna macierzy S: ', num2str(i)]);
    ylim([-1, 1]); % Ustawienie zakresu osi y
    pause(0.5); % Pauza między kolejnymi wierszami i kolumnami
end

% Analiza y = Ax
y = A * x';
y(1:N)

% Wyskalowanie osi poziomej w częstotliwości
freq = (0:N-1) * fs / N; % Wyznaczanie częstotliwości

% Wizualizacja wyników analizy
figure;
stem(freq, abs(y), 'r');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
title('Wyniki analizy: Amplitudy sygnału');

% Rekonstrukcja sygnału
x_r = S * y;
x_s = x_r';
% Sprawdzenie perfekcyjnej rekonstrukcji
if norm(x - x_s) < tolerance
    disp('Transformacja posiada właściwość perfekcyjnej rekonstrukcji.');
else
    disp('Transformacja nie jest idealna.');
end

figure;
subplot(3,1,1);
plot(x);title("x");
subplot(3,1,2);
plot(x_r);title("x reconstructed");
subplot(3,1,3);
plot(x_s);title("x reconstructed transposed")

%x, x_s i x_r to są te same wektory tylko x_r jest wektorem wierszowym,
%dwa pozostałe są wektorami kolumnowymi

%"rozmycie" w poleceniu polega na trudności w określeniu
%nie jest już dokładnie dopasowana do żadnej z funkcji bazowych
%w macierzy transformacji
%funkcje bazowe są funkcjami kosinusowymi o określonych
%częstotliwościach
%wysokie wartości analizy wektora y to dobra korelacja z wektorami
%macierzy A