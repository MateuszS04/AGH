   [inSig,Fs]=audioread('voice_spectrev.wav');
%sygnał ktory wlasnie wczytalismy do zmiennej inSig zawiera fragment tekstu, ktory
%zostal zakodowany tak ze wysokie czestotliwosci zamieniono miejscami z
%niskimi (zamiana górnej i dolnej połówki widma). Przyjmując, że maksymalna częstotliwość w widmie badanego sygnału
%to 4 kHz napisz dekoder który pozwoli na usłyszenie tekstu w czytelnej dla
%człowieka postaci
figure;
pwelch(inSig,4096,[],[],Fs,'centered');
soundsc(inSig,Fs);
x=hilbert(inSig);
t=(0:length(inSig)-1)'/Fs;%Fs-częstotliwość próbkowania
xout=x.*exp(-1i*t*4000*2*pi);%4000*2*pi-to jest nasza omeg , -jX(w)-dlatego exp(-1i*w*t)
outSig=real(xout);
figure;
pwelch(outSig,4096,[],[],Fs,'centered');
soundsc(outSig,Fs);

%tak brzmi zakodowany sygnał
%TODO 1: odkomentuj poniższe linie i napisz dekoder. Użyj funkcji hilbert (przeczytaj uważnie dokumentację!!!) i
%własnej pomysłowości. 
% Wskazówka: Jeśli rozwiązanie zajmuje więcej niż 5 linijek oznacza, że
% robisz coś źle
% outSig=....
soundsc(outSig,Fs); %a tak brzmi sygnał po zdekodowaniu