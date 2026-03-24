clear all
close all
%% ogólne parametry do liczenia
fs=8e3;
t=0:1/fs:1; %wektor czasu
%% parametry do sygnału sinusoidalnego
A1=-0.5;
f1=34.2;
A2=1;
f2=115.5;
% dref=A1*sin(2*pi*f1*t)+ A2*sin(2*pi*t*f2); %sygnał czysty wejściowy

%% parametry do sfm 
fc=1000;
df=500;
fm=0.25;
beta=df/fm;
% dref=sin(2*pi*fc*t + beta*sin(2*pi*fm*t));

%% wczytanie pliku hairdryer
[hairdryer,fs_wav]=audioread('hairdryer.wav');
t_duration=1;
N=fs*t_duration;
% t = (0:length(dref)-1)/fs;

if size(hairdryer,2)>1
    hairdryer=hairdryer(:,1);
end

%amiana częstotliwości próbkowania i długpści nagrania
hairdryer_resampled=resample(hairdryer,fs,fs_wav);
% 
dref=hairdryer_resampled(1:N+1)';%sygnał odniesienia

%% parametry dla mowa

[dref_raw, fs_wav] = audioread('mowa8000.wav'); % <- Zmień plik jeśli chcesz
if size(dref_raw,2) > 1
    dref_raw = dref_raw(:,1); % tylko 1 kanał
end
% dref = resample(dref_raw, fs, fs_wav);
% % dref = dref(1:N+1)';          % skrócenie do 1 sekundy
% dref = dref(:).';
% t = (0:length(dref)-1)/fs;

%% szukamy najlepszych współczynników SNR dla najniższej średniej wartości  SNR 
SNR_levels=[10,20,40];
colors=['r','g','b'];
bestM = 0;                  % długość filtru
bestmi = 0;
bestSNR=-inf;
rng(0);

for M_test=5:2:30
    for mi_test=[0.0005,0.001,0.002,0.0025]
            avgSNR=0;

        for i =1:length(SNR_levels)

            d=awgn(dref,SNR_levels(i),'measured');
            d=d(:).';%część dodana dla mowy
            x = [ d(1) d(1:end-1) ]; % WE: sygnał filtrowany, teraz opóźniony d

            y=zeros(1,length(x));
            e=zeros(1,length(x));
            bx = zeros(M_test,1);        % bufor na próbki wejściowe x
            h = zeros(M_test,1);     % początkowe (puste) wagi filtru


            for n = 1 : length(x)
                bx = [ x(n); bx(1:M_test-1) ];   % pobierz nową próbkę x[n] do bufora
                y(n) = h' * bx;             % oblicz y[n] = sum( x .* bx) – filtr FIR
                e(n) = d(n) - y(n);         % oblicz e[n]
                h = h + mi_test * e(n) * bx;       % LMS
                % h = h + mi * e(n) *       bx /(bx'*bx); % NLMS
            end

            SNR_db=10*log10(sum(dref.^2)/sum((dref-y).^2));
            avgSNR=avgSNR+SNR_db;

        end
          avgSNR=avgSNR/length(SNR_levels);

          if avgSNR>bestSNR
              bestSNR=avgSNR;
              bestM=M_test;
              bestMi=mi_test;
          end
    end
end
fprintf('Najlepsze parametry:\n M = %d, mi = %.4f, średni SNR = %.2f dB\n', bestM, bestMi, bestSNR);

%% Wyniki SNR dla poszczególnych sygnałów 

for i = 1:length(SNR_levels)
    d = awgn(dref, SNR_levels(i), 'measured');
    x = [0 d(1:end-1)];
    y = zeros(1,length(x));
    bx = zeros(bestM,1);
    h = zeros(bestM,1);

    for n = 1:length(x)
        bx = [x(n); bx(1:bestM-1)];
        y(n) = h' * bx;
        e(n) = d(n) - y(n);
        h = h + bestMi * e(n) * bx;
    end

    SNR_db = 10*log10(sum(dref.^2)/sum((dref - y).^2));
    fprintf('SNR po filtracji dla poziomu szumu %d dB: %.2f dB\n', SNR_levels(i), SNR_db);

    figure('Name', sprintf('Poziom szumu %d dB', SNR_levels(i)));

    % 1. Oryginalny
    subplot(4,1,1);
    plot(t, dref, 'k');
    title('Sygnał oryginalny');
    xlabel('Czas [s]'); ylabel('Amplituda');

    % 2. Zaszumiony
    subplot(4,1,2);
    plot(t, d, colors(i));
    title(sprintf('Sygnał zaszumiony (%d dB)', SNR_levels(i)));
    xlabel('Czas [s]'); ylabel('Amplituda');

    % 3. Odszumiony
    subplot(4,1,3);
    plot(t, y, 'c');
    title('Sygnał odszumiony (filtr LMS)');
    xlabel('Czas [s]'); ylabel('Amplituda');

    % 4. Wszystkie razem
    subplot(4,1,4);
    plot(t, dref, 'k', 'DisplayName', 'Oryginalny'); hold on;
    plot(t, d, colors(i), 'DisplayName', 'Zaszumiony');
    plot(t, y, 'c', 'DisplayName', 'Odszumiony');
    title('Porównanie wszystkich sygnałów');
    xlabel('Czas [s]'); ylabel('Amplituda');
    legend;
    % 
    % % Charakterystyka amplitudowo-częstotliwościowa filtru
    figure('Name','Charakterystyka filtru LMS');
    freqz(h, 1, 1024, fs);
    title(sprintf('Charakterystyka amplitudowo-częstotliwościowa (M = %d, μ = %.4f)', bestM, bestMi));

    % % Widmo gęstości mocy
    % fragLen = 1024;
    % frag_dref = dref(end-fragLen+1:end);
    % frag_y = y(end-fragLen+1:end);
    % 
    % [Pxx_orig, F1] = pwelch(frag_dref, [], [], [], fs);
    % [Pxx_filt, F2] = pwelch(frag_y, [], [], [], fs);
    % 
    % figure('Name','Widmo gęstości mocy');
    % plot(F1,10*log10(Pxx_orig), 'b', 'DisplayName', 'Oryginalny');
    % hold on;
    % plot(F2,10*log10(Pxx_filt), 'r', 'DisplayName', 'Po filtracji');
    % xlabel('Częstotliwość [Hz]');
    % ylabel('Widmo mocy [dB]');
    % legend;
    % title(sprintf('Widmo gęstości mocy (szum %d dB)', SNR_levels(i)));
    % 
    % % odsłuch
    % disp('Odsłuch sygnału oryginalnego'); sound(dref, fs); pause(length(dref)/fs + 1);
    % disp('Odsłuch sygnału zaszumionego'); sound(d, fs); pause(length(d)/fs + 1);
    % disp('Odsłuch sygnału po filtracji'); sound(y, fs); pause(length(y)/fs + 1);
    % figure;
    % spectrogram(dref, hamming(256), 200, 512, fs, 'yaxis');
    % title('Spektrogram mowy');
end


