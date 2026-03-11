numSyms=10; %generujemy 10 symboli
sps=100;%liczba probek na symbol
Ts=1e-6;
M=4; %modulation order. Jak widać testujemy modulację QPSK
inData=randi([0 M-1],1,numSyms);

%TODO 2: przekształć wejściowy strumień danych na ciąg symboli QPSK użyj funkcji qammod
symStr=qammod(inData,M); %wygeneruj ciąg symboli QPSK

%TODO 3: w naszym eksperymencie zakładamy szybkosć symbolową 10 ksym/s zatem czas trwania każdego symbolu to 100 taktów zegara
%wydłuż czas trwania symboli znajdujących się w zmiennej symStr z jednego do stu taktów korzystając z funkcji repelem
symStr=repelem(symStr,sps);
%Przygladając się zmiennej symStr można zauważyć, że zawiera ona tzw. dolnopasmową reprezentację zespoloną sygnału
%Krótko mówiąc opisuje ona, w postaci liczby zespolonej, amplitudę i fazę sygnału przy założeniu że jego częstotliwość środkowa (czyli nośna) to 0 Hz
%Jesli chcemy zobaczyć rzeczywistą postać sygnału najprościej będzie jeśli przesuniemy sygnał w dziedzienie częstotliwości np o 30 kHz a następnie weźmiemy z niego jedynie część rzeczywistą

%TODO 4: przesuń sygnał w dziedzinie częstotliwości o 30 kHz mnożąc go
%przez sygnał postaci e^jwt. Użyj funkcji exp i real. W Matlabie jednostke
%urojoną zapisujemy jako 1i
fc=3e4;
t=((0:(length(symStr)-1))/fc);
cplxMod=symStr.*exp(1i*t*2*pi);
% pwelch(cplxMod,4096,[],[],1/Ts,'centered');
realMod=real(cplxMod);
%zrobione? TAK, to oglądamy
title('postać rzeczywista niefiltrowanego sygnału QPSK');
plot(realMod);