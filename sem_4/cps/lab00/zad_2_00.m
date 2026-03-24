clear all;close all;
%wczytywanie pliku dzwiekowego z rozbiciem go na ścieżke i częstotliwość
%próbkowania
[y,fpr] = audioread("speech.wav"); 
Nx=length(y);% wyciaganie z listy skalara próbek (ilości próbek)
t=Nx/fpr; % liczenie czasu z prubek i czestotliwości próbkowania
fprintf("częstotliwość próbkowania: "+fpr+"Hz\n");
fprintf("ilość próbek: "+Nx+"\n");
fprintf("czas: "+t+"s\n");
fprintf("min: "+min(y)+"\n");
fprintf("max: "+max(y)+"\n");
fprintf("odchylenie standardowe: "+std(y)+"\n");
d=2; %współczynnik zmiany częstotliwości odtwarzania
sound(x1,fpr/2);