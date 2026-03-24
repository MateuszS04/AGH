clear all; 
close all; 
clc;

% parametry
pulsacja_graniczna = 2*pi*100;  
f = 0:1:1000;                   
omega = 2*pi*f;                
N = [2 4 6 8];                 
B = {}; A = {};
H_f = {};                       


for i = 1:length(N)
    n = N(i);
    k = 1:n;
    pk = pulsacja_graniczna * exp(1j * (pi/2 + pi/(2*n) + (k-1)*pi/n));
    A{i} = real(poly(pk));  
    B{i} = A{i}(end);       
    Hjw = freqs(B{i}, A{i}, omega);
    H_f{i} = Hjw;
end

figure;
subplot(2,1,1);
hold on;
for i = 1:length(N)%rysujemy amplitudę w decybelach
    plot(f, 20*log10(abs(H_f{i})), 'DisplayName', ['N = ' num2str(N(i))]);
end
title('Charakterystyki amplitudowe (skala liniowa)');
xlabel('Częstotliwość [Hz]'); ylabel('|H| [dB]');
legend; 
grid on;

subplot(2,1,2);
hold on;
for i = 1:length(N)
    semilogx(f, 20*log10(abs(H_f{i})), 'DisplayName', ['N = ' num2str(N(i))]);
end
title('Charakterystyki amplitudowe (skala logarytmiczna)');
xlabel('Częstotliwość [Hz]'); ylabel('|H| [dB]');
legend; grid on;

%kąt fazowy argument zespolony w radianach
figure;
hold on;
for i = 1:length(N)
    plot(f, angle(H_f{i}), 'DisplayName', ['N = ' num2str(N(i))]);
end
title('Charakterystyki fazowe');
xlabel('Częstotliwość [Hz]'); ylabel('Faza [rad]');
legend; grid on;


H4 = tf(B{2}, A{2});  
figure;
impulse(H4);
title('Odpowiedź impulsowa filtru Butterwortha N=4');
grid;

figure;
step(H4);
title('Odpowiedź skokowa filtru Butterwortha N=4');
grid;




