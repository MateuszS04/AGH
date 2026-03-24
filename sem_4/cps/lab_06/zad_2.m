%%
% Wybierz plik odpowiadający przedostatniej cyfrze Twojego numeru 
% legitymacjistudenckiej i rozkoduj go. 
% Sygnał s.wav to sygnał wzorcowy składający się z sekwencji
% [1,2,3,4,5,6,7,8,9,*,0,#].

[s5,fs] = audioread('s5.wav');

%%
% Rozkoduj sekwencje ,,ręcznie'' patrząc na wykres czasowo-częstotliwościowy 
% tego sygnału (funkcjaspectrogram

figure('Name', 'wykres czasowo-częstotliwościowy sygnału s5');
spectrogram(s5, 4096, 4096-512, [0:5:2000], fs);
title('wykres czasowo-częstotliwościowy sygnału s5');
% Wyszło 39335

%% Dane z Zad1
N  = length(s5);        % liczba probek
dt = 1/fs;              % krok próbkowania

df = fs/N;
f  = 0:df:fs-df;
w  = 2*pi*f;

load('butter.mat');

%% Tworzenie filtru cyfrowego

[zd,pd,kd] = bilinear(z,p,k,fs);

z  = exp(j*w/fs);
bm = poly(zd)*kd;          
an = poly(pd);

%%
% Przefiltruj sygnał s5 cyfrowym filtrem BP z ćwiczenia 1. 
% Porównaj spektrogramy przed i po filtracji.
% Narysuj na jednym rysunku oba sygnały w dziedzinie czasu. 
% Skompensuj opóźnienie sygnału wprowadzone przez filtrację.

y5 = filter(bm,an,s5);

figure('Name', 'wykres czasowo-częstotliwościowy sygnału y5 (po filtracji BP)');
spectrogram(y5, 4096, 4096-512, [0:5:2000], fs);
title('wykres czasowo-częstotliwościowy sygnału y5');

%%
% Porównaj spektrogramy przed i po filtracji.
% Narysuj na jednym rysunku oba sygnały w dziedzinie czasu.

t = dt*(0:N-1);
figure('Name', 'Porównanie sygnałów w dziedzinie czasu');
subplot(2,1,1);
plot(t, s5,'b');
title('Sygnał wejściowy s5');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;

subplot(2,1,2);
plot(t, y5,'b');
title('Sygnał wyjściowy y5');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;


 %% Analiza przy użyciu algorytmu Goertzla

% Częstotliwości DTMF (Hz)
dtmf_freqs = [697 770 852 941 1209 1336 1477];

% Parametry
frame_size = 205;  % dzielimy sygnał na ramki
num_frames = floor(length(s5)/frame_size);

% Wynik przechowujący moc sygnału dla każdej częstotliwości w każdym oknie
power_matrix = zeros(num_frames, length(dtmf_freqs));

for k = 1:num_frames %pętla po wszytkich ramkach
    frame = s5((k-1)*frame_size + 1 : k*frame_size);
    for f_idx = 1:length(dtmf_freqs)%tutaj przechodzimy po wszytskich częstotliwościach do wykrycia 
        freq = dtmf_freqs(f_idx);
        % Indeks Goertzla
        k_goertzel = round(freq * frame_size / fs);%indeks częstotlwiości 
        omega = 2 * pi * k_goertzel / frame_size;%kąt dla tej częstotliwości 
        coeff = 2 * cos(omega);%współczynnik potrzebny do rekurencji

        s_prev = 0;% ski pamiętają poprzedni stan 
        s_prev2 = 0;

        for n = 1:frame_size%dla każdej próbki obliczamy nowe s w oparciu o poprzednie wartości
            s = frame(n) + coeff * s_prev - s_prev2;
            s_prev2 = s_prev;
            s_prev = s;
        end

        power = s_prev2^2 + s_prev^2 - coeff * s_prev * s_prev2;%liczymy moc na zadanej częstotliwoćci
        power_matrix(k, f_idx) = power;%Zapisuje się moc sygnału na tej częstotliwości w danym oknie.
    end
end

% Wykres mapy częstotliwości DTMF w czasie
figure('Name','Wykrycie DTMF metodą Goertzla');
imagesc(1:num_frames, dtmf_freqs, 10*log10(power_matrix'));
axis xy;
xlabel('Ramy czasowe');
ylabel('Częstotliwość [Hz]');
title('Moc sygnału DTMF (Goertzel)');
colorbar;
 
%% Automatyczne rozpoznawanie DTMF bez ręcznego frame_shift
% 
% 
frame_len = 1024; 
threshold = 0.1; 

dtmf_freqs_low = [697, 770, 852, 941];
dtmf_freqs_high = [1209, 1336, 1477];

dtmf_keys = ['1','2','3';
             '4','5','6';
             '7','8','9';
             '*','0','#'];

window = hamming(frame_len);%koorzystamy z okna hamminga do minimalizacji zakłóceń 


step = round(frame_len/4); %i ustawiamy przesunięcie ramki na 1/4 jej długości 
num_frames = floor((length(s5)-frame_len)/step) + 1;
energy = zeros(1, num_frames);

for i = 1:num_frames  %Dzielimy sygnał na ramki i dla każdej obliczmay energię
    idx = (i-1)*step + 1;
    frame = s5(idx:idx+frame_len-1);
    energy(i) = sum((frame .* window).^2);
end

energy = energy / max(energy);%normalizujemy energię sygnału  na przedział od 0-1

active = energy > threshold;%szukamy tonów gdzie energia przekracza próg
changes = diff([0 active 0]);
start_indices = find(changes == 1);%początek tonu 
stop_indices = find(changes == -1) - 1;%koniec tonu

digits = '';

for i = 1:length(start_indices)% dla każdego tonu wycinamy dokładny kawałek sygnału
    start_frame = start_indices(i);
    stop_frame = stop_indices(i);

    idx_start = (start_frame-1)*step + 1;
    idx_stop = (stop_frame-1)*step + frame_len;

    if idx_stop > length(s5)
        idx_stop = length(s5);
    end

    tone = s5(idx_start:idx_stop);


    if length(tone)/fs < 0.04 % ignorujemy za krótkie tony
        continue;
    end

    tone = tone .* hann(length(tone));%przekształcamy na widmo FFT
    N = 2^nextpow2(length(tone));
    spectrum = abs(fft(tone, N));
    spectrum = spectrum(1:N/2);

    f = (0:N/2-1)*(fs/N);%generujemy częstotliwości

  
    [~, idxs] = maxk(spectrum, 10); % bierzemy 10 najmocniejszych częstotliwości z widma
    detected_freqs = f(idxs);

    low_candidates = detected_freqs(detected_freqs < 1100);%dzielimy na niskie i wysokie
    high_candidates = detected_freqs(detected_freqs > 1100);


    tolerance = 20;

    low = [];%szukamy najbliższych dopasowań do częstotliwości
    for freq = low_candidates
        [min_diff, ind] = min(abs(dtmf_freqs_low - freq));
        if min_diff < tolerance
            low = dtmf_freqs_low(ind);
            break;
        end
    end

    high = [];
    for freq = high_candidates
        [min_diff, ind] = min(abs(dtmf_freqs_high - freq));
        if min_diff < tolerance
            high = dtmf_freqs_high(ind);
            break;
        end
    end

    if ~isempty(low) && ~isempty(high) %przypisujemy znalezione częstotliwości do liczb
        row = find(dtmf_freqs_low == low);
        col = find(dtmf_freqs_high == high);

        detected_digit = dtmf_keys(row, col);
        digits(end+1) = detected_digit;
    end
end

disp('Odczytana sekwencja DTMF:');
disp(digits);
