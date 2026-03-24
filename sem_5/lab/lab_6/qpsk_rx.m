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
% headF=-headF; jest potrzebne jak nie ma fragmentu poniżej
% 

start_idx=1;
L=length(headF);

idx_vec = start_idx : sps : (start_idx + (L-1)*sps);% pobieramy fragment sygnału

receivedHeader=iq(idx_vec);

% receivedHeader = iq(start_idx:start_idx+L-1)

X=receivedHeader.*conj(headF);%mnożymy odebrany sygnał przez sprzężenie idealanego sygnału usuwając informację o symbolach
%zmienna X zawiera teraz czysty błąd fazy 
rho=sum(X(2:end).*conj(X(1:end-1)));
omega_hat=angle(rho); % bierzemy kąt

omega_hat_sample=omega_hat/sps;

n=(0:length(iq)-1)';% wektor czasu
iqOut=iq.*exp(-1j*omega_hat_sample*n);% "odkręcamy" fazę z powrotem do poprawnej

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
