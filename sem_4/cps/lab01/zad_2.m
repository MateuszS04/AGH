% Parametry sygnału
A = 230;           
fs = 100;          
fs3 = 200;         
fs_high = 10000;  
T = 1;             
% Generowanie sygnału spróbkowanego

n = 0:1/fs3:T;
x_sampled = A * sin(2 * pi * 50 * n);

% Rekonstrukcja za pomocą sinc
ts = 0:1/fs_high:T;
x_reconstructed = zeros(size(ts));

for idx = 1:length(ts)
    t = ts(idx);
    for k = 1:length(n)
        x_reconstructed(idx) = x_reconstructed(idx) + x_sampled(k) * sinc(fs3 * (t - n(k)));
    end
end

% Oryginalny sygnał pseudo-analogowy
t_analog = 0:1/fs_high:T;
x_analog = A * sin(2 * pi * 50 * t_analog);

% Rysowanie porównania
figure;
plot(t_analog, x_analog, 'b-', 'LineWidth', 1.5); % Oryginalny sygnał
hold on;
plot(ts, x_reconstructed, 'g--', 'LineWidth', 1.2); % Zrekonstruowany sygnał
stem(n, x_sampled, 'ro'); % Punkty próbek
hold off;

title('Rekonstrukcja sygnału za pomocą sinc(x)');
xlabel('Czas [s]');
ylabel('Napięcie [V]');
legend('Pseudo-analogowy', 'Zrekonstruowany', 'Próbki');
grid on;

% Obliczenie błędu rekonstrukcji
error_signal = x_analog - interp1(ts, x_reconstructed, t_analog, 'linear', 'extrap');

figure;
plot(t_analog, error_signal, 'm');
title('Błąd rekonstrukcji');
xlabel('Czas [s]');
ylabel('Błąd [V]');
grid on;