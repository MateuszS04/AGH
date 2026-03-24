clear all
close all
load('contRx.mat'); %Do zmiennych Iq oraz Fs ³adujemy próbki oraz czêstotliwoœæ próbkowania
%tutaj nale¿y umieœciæ kod odbiornika który pozwoli na odtworzenie
%kolejnych symboli modulacji. Jedna próbka = jeden symbol modulacji
%i umieszczenie jej w zmiennej rxSyms
%Nastêpnie idziemy na skróty i korzystamy z gotowego demodulatora
%Ca³a reszta to ju¿ tylko dekodowanie strumienia bitów. Jeœli masz ochotê
%zobaczyæ jak to siê odbywa zajrzyj do skryptu streamDecode
demod = comm.DQPSKDemodulator('BitOutput',true,'PhaseRotation',0);
A=demod.step(rxSyms);
outData=streamDecode(A);
disp(outData');
