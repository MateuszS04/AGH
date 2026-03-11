% Przykładowe użycie
if ~isdeployed
    % Długość generowanej sekwencji PRBS
    sequence_length = 100;

    % Stan początkowy rejestru przesuwnego (b1 do b9)
    initial_state = randi([0,1],1,9); % Przykładowe wartości

    % Generowanie sekwencji PRBS
    prbs = generate_prbs(sequence_length, initial_state);

    % Obliczenie widma w dziedzinie częstotliwości za pomocą FFT
    prbs_fft = fft(prbs);
    prbs_magnitude = abs(prbs_fft(1:floor(end/2))); % Amplituda widma (połówka FFT)
    freq = linspace(0, 0.5, length(prbs_magnitude)); % Normalizowana częstotliwość

    % Wykres sekwencji PRBS
    figure;
    subplot(2, 1, 1); % Górny wykres
    stem(prbs, 'b', 'filled');
    title('y(n)');
    xlabel('n');
    ylabel('y');
    xlim([0 length(prbs)]); % Dostosowanie zakresu osi
    grid on;

    % Obliczenie autokorelacji
    autocorr = xcorr(prbs - mean(prbs)); % Usunięcie wartości średniej dla lepszej analizy
    k = -(length(prbs)-1):(length(prbs)-1); % Osie przesunięcia

    % Wykres autokorelacji
    subplot(2, 1, 2); % Dolny wykres
    stem(k, autocorr, 'b', 'filled');
    title('Ryy(k)');
    xlabel('k');
    ylabel('Autokorelacja');
    grid on;
end