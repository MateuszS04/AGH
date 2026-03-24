clear;
close all;

[x, fs] = audioread('DontWorryBeHappy.wav');
amp = input('Amplituda sygnału (≦ 1): ');
sig = x * amp / max(abs(x));

N = length(sig);
qsig = sig;

bits = input('Liczba bitów (2, 3 lub 4): ');
L = 2^bits;

% współczynniki adaptacji (xm) zależnie od liczby poziomów
if L == 4
    xm = [0.8, 1.6];
elseif L == 8
    xm = [0.9, 0.9, 1.25, 1.75];
elseif L == 16
    xm = [0.8, 0.8, 0.8, 0.8, 1.2, 1.6, 2.0, 2.4];
else
    error('Liczba bitów musi być 2, 3 lub 4!');
end

zmax = 1.0;
zmin = 0.001 * zmax;
z = 0.2 * zmax; % początkowy zakres pracy

mp = input('Liczba współczynników predykcji (M > 0): ');
beta = input('Szybkość adaptacji beta (np. 0.1): ');

ai = zeros(mp, 1); % współczynniki predykcji
buf = zeros(mp, 1); % bufor M próbek

for i = 1:N
    snp = buf' * ai;             % predykcja
    en = sig(i) - snp;           % błąd predykcji

    [nr, wy] = kwant_rown(L, z, en); % kwantyzacja
    z = z * xm(abs(nr));             % adaptacja kwantyzatora

    % ograniczenie z do zmin/zmax
    z = max(min(z, zmax), zmin);

    qsig(i) = wy + snp;          % sygnał zrekonstruowany

    ai = ai + beta * wy * buf;   % adaptacja predyktora
    buf = [qsig(i); buf(1:mp - 1)]; % przesunięcie bufora

    if norm(ai) > 1e6
        disp('Niestabilność numeryczna – zmniejsz beta!');
        break;
    end
end

% Obliczenie błędu i SNR
qerr = sig - qsig;

snr_val = snr(sig(20:N), qerr(20:N));
fprintf('SNR: %.2f dB\n', snr_val);

% Wykresy
figure;
plot(sig, 'b'); hold on;
plot(qsig, 'g');
plot(qerr, 'r');
legend('Oryginalny', 'Zrekonstruowany', 'Błąd');
title('Sygnały: oryginalny, zrekonstruowany i błąd');

