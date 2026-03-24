clear all;
close all;
load("lab08_fm.mat"); 

% Parametry
fc = 200e3;         
fs = 2e6;           
M = 250;            
N = 2*M + 1;
%% Metoda 2

n = -M:M;
hD = cos(pi*n) ./ n;
hD(M+1) = 0;  % wartość w n = 0
w = kaiser(N, 8)';
hD = hD .* w;

f_low = 100e3 / (fs/2);
f_high = 300e3 / (fs/2);
hBP = fir1(N-1, [f_low f_high], 'bandpass', kaiser(N, 8));

% Filtr różniczkujący pasmowo-przepustowy = splot
h = conv(hD, hBP);

y = filter(h, 1, x);

% Obwiednia
y = y.^2;

hLP = fir1(N-1, 8e3/(fs/2), 'low', kaiser(N, 8));
y = filter(hLP, 1, y);

% Pierwiastkowanie
y = sqrt(y);

% Resampling (do 8 kHz)
y = resample(y, 8000, fs); 

% Odsłuch i wykres
soundsc(real(y), 8000);
pause(length(y)/8000 +3)
t = (0:length(y)-1)/8000;
figure;
plot(t, y);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Zdemodulowany sygnał mowy (FM)');
grid on

%% Metoda 3

x_bp = filter(hBP, 1, x);  % filtracja pasmowa

%prosty filtr
b = [-1 1];
a = 1;
y_3 = filter(b, a, x_bp);  % różniczkowanie

% obwiednia
y_3 = y_3.^2;
hLP = fir1(N-1, 8e3/(fs/2), 'low', kaiser(N, 8));
y_3 = filter(hLP, 1, y_3);
y_3 = sqrt(y_3);
y_3 = resample(y_3, 8000, fs);

soundsc(real(y_3), 8000);
pause(length(y_3)/8000 +1)
t = (0:length(y_3)-1)/8000;
figure;
plot(t, y_3);
title("Trzecia metoda: BP + trywialne różniczkowanie");
xlabel("Czas [s]");
ylabel("Amplituda");
grid on;


%% Projekt filtru bez składania 

% --- FIRLS: projekt pasmowo-różniczkującego filtru ---
N = 400;  % długość filtru (większa niż poprzednio)
f_low = 100e3;
f_high = 300e3;
% Normalizacja
f = [0 f_low f_low f_high f_high fs/2]/(fs/2);

% Amplituda różniczkująca w paśmie
a = [0 0 2*pi*f_low 2*pi*f_high 0 0] / (2*pi*fs/2);

h_firls = firls(N, f, a);  % projekt FIR

% --- Filtracja ---
y_2_2 = filter(h_firls, 1, x);

% --- Obwiednia ---
y_2_2 = y_2_2.^2;
hLP = fir1(250, 8e3/(fs/2), 'low', kaiser(251, 8));
y_2_2 = filter(hLP, 1, y_2_2);
y_2_2 = sqrt(y_2_2);
y_2_2 = resample(y_2_2, 8000, fs);

% --- Odsłuch i wykres ---
soundsc(real(y_2_2), 8000);
t = (0:length(y_2_2)-1)/8000;
figure;
plot(t, y_2_2);
title("Filtr zaprojektowany przez firls (różniczkujący BP)");
xlabel("Czas [s]");
ylabel("Amplituda");
grid on;
