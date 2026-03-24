f1=95e6;
f2=97e6;
fs1=94e6;
fs2=98e6;

% f1 = 95.9e6;   
% f2 = 96.1e6;  
% fs1 = 95.8e6;   
% fs2 = 96.2e6; 

wp=[f1 f2]*2*pi;%zmiana pasma przpustowego na radiany
ws=[fs1 fs2]*2*pi;

Bw=wp(2)-wp(1);%obliczmy szerokość pasma przepustowego
w0=sqrt(wp(1)*wp(2));%obliczmay częstotliwość środkową(średia geometryczna pomiędzy f1 i f2)

Wp_lp=1;%normalizowana częstotliwość pasma przustowego filtru Lp, ustawiamy na 1 co oznacza, że pasmo jest w pełni aktywne 
ws_lp=min(abs(ws.^2-w0^2)./(Bw*ws));%normalizowana częstotliwość pasma zaporowego.
%Wartości tej matlab używa do obliczenia wymaganej częstotliwości zaporowej
%Została obliczona z wykorzystaniem szerokości pasma i częstotliwości
%środkowej 
Rp=3;%dopuszczalen zafalowanie w paśmie środkowym
Rs=40;%tłumienie w paśmie zaporowym

[N,Wn]=ellipord(Wp_lp,ws_lp,Rp,Rs,'s');%funkcja ellipord oblicza rząd filtru N, aby spełniał postawione w zadaniu wymagania 
[b_lp,a_lp]=ellip(N,Rp,Rs,Wn,'s');%tworzenie filtru elliotycznego

[b_bp,a_bp]=lp2bp(b_lp,a_lp, w0, Bw);%przekształcenie filtru dolonoprzepustowego na pasmowoprzepustowy

freq = linspace(92e6, 100e6, 1000);
% freq = linspace(95.5e6, 96.5e6, 2000);
w = 2*pi*freq;
h = freqs(b_bp, a_bp, w);

figure;
plot(freq, 20*log10(abs(h)));
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('Wzmocnienie [dB]');
title('Charakterystyka częstotliwościowa filtru BP (96 MHz ±1 MHz)');
hold on;
yline(-3, '--r');
yline(-40, '--k');

Granice pasma
xline(95e6, '--g', '95 MHz');
xline(97e6, '--g', '97 MHz');
xline(94e6, '--b', '94 MHz');
xline(98e6, '--b', '98 MHz');
legend('Wzmocnienie', '-3 dB', '-40 dB', 'Pasmo przepustowe', 'Pasmo zaporowe');
disp(['Rząd filtru: ', num2str(N)]);
% 
% xline(95.9e6, '--g', '95.9 MHz');
% xline(96.1e6, '--g', '96.1 MHz');
% xline(95.8e6, '--b', '95.8 MHz');
% xline(96.2e6, '--b', '96.2 MHz');
% legend('Wzmocnienie', '-3 dB', '-40 dB', 'Pasmo przepustowe', 'Pasmo zaporowe');
% disp(['Rząd filtru: ', num2str(N)]);
