clear all
close all
%odbiornik QPSK wyposażony w zgrubna korekcje CFO na bazie preambuły
%% wczytanie danych z pliku
bbr = comm.BasebandFileReader('testQpskOnly.bb');
bbr.SamplesPerFrame=1e6;
sps=64;%samples per symbol
fs=bbr.SampleRate;
iq=bbr();
bbr.release();
% figure; pwelch( iq, 4096, 2048, [], fs, 'centered');

%% Filtracja filtrem dopasowanym
rolloff =0.35; %wspolczynnik poszerzenia pasma
% TODO 1: przeprowadz filtracje kanałową pamiętaj o odpowiedniej decymacji
% sygnału wynik operacji przypisz do zmiennej iq
filter_rrc=rcosdesign(rolloff,10,sps);
iq=upfirdn(iq,filter_rrc,1,sps);
figure; pwelch( iq, 4096, 2048, [], fs, 'centered');

%%
%% AGC
%  TODO 2: dokonaj automatycznej regulacji wzmocnienia (metoda dowolna). nie musi
% byćw czasie rzeczywistym. Wynik przypisz do zmiennej iq
agc=comm.AGC();
iq=agc(iq);

%% wyszukiwanie nagłówka i wstępna korekcja częstotliwoćsi
% TODO 3: To zadanie jest opcjonalne. 
% Jeśli masz chęć możesz dokonać wstępnej korekcji częstotliwości na
% podstawie nagłówka ramki sygnału. Kolejne 5 linii kodu tworzy lokalną
% kopię nagłówka w postaci symboli QPSK. Wynik znajdziesz w zmiennej headF,
% jak wykorzystać go do uzyskania estymaty CFO? Pomyśl sam albo zapytaj
% prowadzącego
hQAMMod = comm.GeneralQAMModulator;
hQAMMod.Constellation = [-1-1i 1-1i -1+1i 1+1i];
header = double(hexToBinaryVector('ACDDA4E2F28C20FC',64,'MSBFirst')');
inData=bi2de(reshape(header,2,[])','left-msb');
headF = step(hQAMMod, inData);

 

start_idx=1;
L=length(headF);

idx_vec = start_idx : sps : (start_idx + (L-1)*sps);

receivedHeader=iq(idx_vec);



X=receivedHeader.*conj(headF);
 
rho=sum(X(2:end).*conj(X(1:end-1)));
omega_hat=angle(rho); 

omega_hat_sample=omega_hat/sps;

n=(0:length(iq)-1)';
iqOut=iq.*exp(-1j*omega_hat_sample*n);

%% usuniecie offsetu częstotliwości
% TODO 4: wyznacz i usun offset częstotliwości z sygnału iq. Wynikowy
% sygnał oraz wektor błędu umieść w zmiennych constel oraz errC

[constel,errC]=costasLoopM(iqOut,2*pi/100,1);
% [constel,errC]=costasLoopM(iq,2*pi/100,1);
figure; plot(errC);
figure; plot(constel,'.');

%% rozwiazanie problemu niejednoznaczności fazy początkowej
% TODO 5: dokonaj korekcji niejednoznaczności fazy początkowej

constel=correctPhaseUncert(constel,headF);
%UWAGA: na obecnym etapie prac interesujemy się jedynie uzyskaniem diagramu
%konstelacji. Oznacza to, że cały odbiornik nie musi zadziałać!

%% demodulacja QPSK
demod = comm.GeneralQAMDemodulator([-1-1i 1-1i -1+1i 1+1i],'BitOutput',true);
% bit=demod.step(constel.');
symb=constel(:);
bit=demod.step(symb);

%% odtworzenie strumienia danych
outPack=streamDecode(bit);
disp(outPack');


function constel_corrected = correctPhaseUncert(constel,headF)
constel=constel(:);
headF=headF(:);


search_window=500;

if length(constel)<search_window
    search_window=length(constel);
end

% [c,lags]=xcorr(constel(1:search_window),headF);
[c,~]=xcorr(constel(1:search_window),headF);

[~,max_idx]=max(abs(c));
% best_lag=lags(max_idx);

peak_value=c(max_idx);
phase_offset_rad=angle(peak_value);

k_float=phase_offset_rad/(pi/2);
k_int=round(k_float);
final_correction=k_int*(pi/2);

rotator=exp(-1i*final_correction);
constel_corrected=constel*rotator;
% constel_corrected=constel_corrected(:);

end