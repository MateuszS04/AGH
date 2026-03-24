clear all
close all
[inSamples,Fs] = audioread('tetra_IQ.wav');%sygnał który czytamy ma fs=36ksps
IqSamples=inSamples(:,1) + 1i*inSamples(:,2);
clear inSamples;


%% ta sekcja to sekwencje synchronizacyjne dla Tetry normalnie przydają się ts3
% oraz syncTs - która pozwala od razu estymować offset czŕstotliwości
ts1=[1 1 0 1 0 0 0 0 1 1 1 0 1 0 0 1 1 1 0 1 0 0];
ts1=[1 1 0 1 0 0 0 0 1 1 1 0 1 0 0 1 1 1 0 1 0 0];
ts2=[0 1 1 1 1 0 1 0 0 1 0 0 0 0 1 1 0 1 1 1 1 0];
ts3=[1 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 0 1 1 0 1];
extTs=[1 0 0 1 1 1 0 1 0 0 0 0 1 1 1 0 1 0 0 1 1 1 0 1 0 0 0 0 1 1];
syncTs=[1 1 0 0 0 0 0 1 1 0 0 1 1 1 0 0 1 1 1 0 1 0 0 1 1 1 0 0 0 0 0 1 1 0 0 1 1 1];
freqCor=[ones(1,8) zeros(1,64) ones(1,8)];


%% TODO 1 - unormuj amplitudę sygnału odbieranego czyli dokonaj AGC
agc=comm.AGC;
IqSamples=agc(IqSamples);
figure
pwelch(IqSamples,4096,2048,[],Fs,'centered')
%% TODO 2 - odfiltruj szum pozapasmowy korzystając filtru RRC oraz zredukuj dwukrotnie częstotliwość próbkowania (rcosdesign, upfirdown)
beta=0.35;
spn=10;
sps=2;
filtr_rrc=rcosdesign(beta,spn,sps);
IqSamples=upfirdn(IqSamples,filtr_rrc,1,sps);
figure
pwelch(IqSamples,4096,2048,[],Fs,'centered')

%% TODO 3 wyszukaj wszystkie sekwencje syncTs (filter, flipud,abs,tetraMOD)
syms_all=tetraMod(syncTs); % generowanie symbloi SyncTs
syncTs_syms=syms_all(2:end);% pobieramy 19 symboli
symbol_length=length(syncTs_syms);

filter_sync=conj(flipud(syncTs_syms));% przygotowanie filtra dopasowanego

corr_output=filter(filter_sync,1,IqSamples);% korelacja w dziedzinie częstotliwości

abs_correlation=abs(corr_output);% znalezienie maksimum początku ramki
[max_corr_val,start_sample_index]=max(abs_correlation);
frame_start_index=start_sample_index-symbol_length+1;% wyliczenie skorygowanego indeksu początkowego
disp('--- Wyniki Korelacji ---');
disp(['Pik korelacji (wartość): ', num2str(max_corr_val)]);
disp(['Indeks początku ramki (symbole): ', num2str(frame_start_index)]);
cfo_phase_error = angle(corr_output(start_sample_index)); % zapisanie fazy korealcji

%% TODO 4 na podstawie sekwencji synchronizacyjnych wyznacz offset częstotliwości/fazy dla poszczegolnych burstów
ts3_syms_all = tetraMod(ts3);
ts3_syms = ts3_syms_all(2:end); 
ts3_length = length(ts3_syms); % Długość ts3 to 19 symboli
filter_ts3 = conj(flipud(ts3_syms));

% W TETRA, burst ma 510 symboli. ts3 jest zlokalizowana centralnie.
% Lokalizacja ts3: symbole 246 do 264 (zaczynając od 1)
ts3_start_idx = 246; % Indeks w ramce, gdzie zaczyna się ts3
ts3_end_idx = ts3_start_idx + ts3_length - 1;

% Krok 2: Wycinek sygnału wokół ts3
% Bierzemy wystarczająco duży bufor wokół spodziewanej lokalizacji ts3,
% aby znaleźć najlepsze dopasowanie
ts3_search_range = IqSamples(ts3_start_idx-10 : ts3_end_idx+10); 

% Krok 3: Korelacja na wycinku
correlation_ts3 = filter(filter_ts3, 1, ts3_search_range);


% Szukamy dokładnego piku w buforze
[~, ts3_max_index_in_search] = max(abs(correlation_ts3));

% Krok 4: Wyznaczenie błędu fazy/częstotliwości
% Wartość zespolona w piku zawiera resztkowy błąd fazy
cfo_res_phase_error = angle(correlation_ts3(ts3_max_index_in_search));

disp(['Resztkowy błąd fazy (kąt korelacji ts3): ', num2str(cfo_res_phase_error), ' radianów']);

%% TODO 5 usun offset częstotliwości/fazy z sygnału wejściowego

% Korekcja fazy stałej: Obracamy całą konstelację.
IqSamples_cfo_corr = IqSamples * exp(-1i * cfo_res_phase_error);

% Korekcja częstotliwości: (Jeśli błąd CFO jest znaczący, wymagana jest 
% estymacja nachylenia fazy na długim odcinku, np. na ts3).
% Tutaj zakładamy, że wstępna korekcja na syncTs usunęła główny błąd, 
% a teraz usuwamy stały błąd fazy.

IqSamples = IqSamples_cfo_corr; % Zaktualizowany sygnał wejściowy

figure
plot(IqSamples, '.')
title('Konstelacja po Korekcji Fazy na ts3')
xlabel('I')
ylabel('Q')
axis equal

%% TODO 6 dokonaj demodulacji ()
% bitStream=...;%tutaj wynikiem powinien być wierszowy wektor bitów zawierajacych zera lub jedynki
%% TODO 6 - dokonaj demodulacji (pi/4-DQPSK)

% Krok 1: Obliczenie różnic faz
% Symbole pi/4-DQPSK są różnicowe: S_k = S_{k-1} * d_k
% d_k = S_k / S_{k-1}
% Potrzebujemy wszystkich symboli poza pierwszym (S0)
d_k = IqSamples(2:end) ./ IqSamples(1:end-1); 

% Krok 2: Normalizacja i wyznaczenie kąta (różnicy faz)
% Używamy atan2/angle, by uzyskać kąt w zakresie (-pi, pi]
delta_phi = angle(d_k);

% Krok 3: Przypisanie różnicy faz do symboli (Mapowanie)
% W pi/4-DQPSK możliwe różnice faz są: pi/4, 3*pi/4, -pi/4, -3*pi/4.
% Mamy 4 ćwiartki:
% Case 0 (00): pi/4
% Case 1 (01): 3*pi/4
% Case 2 (10): -pi/4
% Case 3 (11): -3*pi/4

bitStream = [];
for i = 1:length(delta_phi)
    phi = delta_phi(i);
    
    % Zaokrąglamy do najbliższego kąta TETRA.
    % To jest decyzyjny krok demodulacji.
    if (phi > 0) && (phi < pi/2)
        % ~pi/4 (0.785 rad)
        bits = [0 0]; % Case 0
    elseif (phi >= pi/2) && (phi < pi)
        % ~3*pi/4 (2.356 rad)
        bits = [0 1]; % Case 1
    elseif (phi <= 0) && (phi > -pi/2)
        % ~-pi/4 (-0.785 rad)
        bits = [1 0]; % Case 2
    else % (phi <= -pi/2) && (phi > -pi)
        % ~-3*pi/4 (-2.356 rad)
        bits = [1 1]; % Case 3
    end
    bitStream = [bitStream bits];
end

bitStream=bitStream; % Wektor bitów (wierszowy)
%% zapisanie wyniku w pliku akceptowalnym przez parser tetra-rx
streamSave('tetraBitStream.bin',bitStream);

