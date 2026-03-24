load("ECGDATA.mat");
N=10000;
ekg = ECGData.Data(1, 1:N); % Użyj pierwszego kanału z 162 dostępnych
fs = 1000;  

t = (0:length(ekg)-1)/fs;

f_noise = 50;
noise = 0.2 * sin(2*pi*f_noise*t);
ekg_noisy = ekg + noise;

reference_signal = sin(2*pi*f_noise*t);

M = 32;
mu = 0.001;
gamma = 1e-6;

[y_1,filtered_signal, errors] = lms_adaptive_identification(reference_signal', ekg_noisy, M, mu, gamma, 1);

figure;
subplot(3,1,1);
plot(t, ekg);
title('Oryginalny sygnał EKG');

subplot(3,1,2);
plot(t, ekg_noisy);
title('EKG z zakłóceniem 50 Hz');

subplot(3,1,3);
plot(t, errors);
title('Sygnał po filtrze adaptacyjnym ');
xlabel('Czas [s]');


%% Zakłócanie szumem gaussowskim – symulacja zakłóceń EMG

% Parametry filtru dolnoprzestowego
fc_emg = 150;  % Maks. częstotliwość EMG (wg literatury medycznej)
[b_emg, a_emg] = butter(4, fc_emg/(fs/2), 'low');  % Filtr 4. rzędu

% Wygeneruj szum i przefiltruj (symulacja EMG)
emg_noise = filter(b_emg, a_emg, randn(size(ekg)));

% Dodaj szum EMG do sygnału EKG
ekg_noisy_emg = ekg + 0.2 * emg_noise;

% --- 1. Adaptacyjne usuwanie interferencji (AI) ---
[y_out_1,~, errors_ai] = lms_adaptive_identification(emg_noise', ekg_noisy_emg, M, mu, gamma, 1);

% --- 2. Adaptacyjna liniowa predykcja (LP) ---
d = ekg_noisy_emg(M+1:end);         % Sygnał docelowy (z opóźnieniem M)
x = zeros(length(d), M);            % Regresory

for i = 1:M
    x(:, i) = ekg_noisy_emg(M+1 - i:end - i);  % Tworzenie przeszłych próbek
end

[y_out_2,~, errors_lp] = lms_adaptive_identification(x', d', M, mu, gamma, 1);

% --- Dopasowanie długości do porównań SNR ---
L_ai = min(length(errors_ai), length(ekg));
L_lp = min(length(errors_lp), length(ekg) - M);

% Zapewniamy, że wszystko to wektory kolumnowe
e_ai = errors_ai(1:L_ai)';
orig_ai = ekg(1:L_ai);

e_lp = errors_lp(1:L_lp)';
orig_lp = ekg(M+1:M+L_lp);

snr_ai = snr(orig_ai(:), (orig_ai(:) - e_ai(:)));
snr_lp = snr(orig_lp(:), (orig_lp(:) - e_lp(:)));


% --- Wyświetlenie wyników ---
fprintf('SNR dla adaptacyjnego usuwania interferencji (AI): %.2f dB\n', snr_ai);
fprintf('SNR dla adaptacyjnej liniowej predykcji (LP): %.2f dB\n', snr_lp);

