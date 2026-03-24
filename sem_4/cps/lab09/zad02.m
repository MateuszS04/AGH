clear all
close all


%% Parametry filtru rzeczywistego 
L=256;  %256 bo matlab indeksuje od 1 więc i=255
h_true=zeros(1,L);
h_true(256)=0.8;
h_true(121)=-0.5;
h_true(31)=0.1;
h_true=h_true(:);


[x_mowa,fs]=audioread('mowa8000.wav');
x_mowa=x_mowa(:)';% robimyy żeby napewno był to wektor wierszowy

d_mowa=conv(x_mowa,h_true,'full'); %sygnał odnieseinia w postaci sygnału przepuszczonego przez filtr

%% szum biały

x_noise=randn(size(x_mowa));
d_noise=conv(x_noise,h_true,'full');


%% Prametry filtru adaptacyjnego lms

M=256;
mu=0.001;

[y_mowa,h_mowa,~]=lms_adaptive_identification(x_mowa,d_mowa,M,mu,0,1); %lms z sygnałem mowy

[y_noise,h_noise,~]=lms_adaptive_identification(x_noise,d_noise,M,mu,0,1);

%% wykorzystanie nlms

% M=256;
% mu=0.001;
% gamma=1e-6;
% 
% [y_mowa,h_mowa,~]=lms_adaptive_identification(x_mowa,d_mowa,M,mu,gamma,2); %lms z sygnałem mowy
% 
% [y_noise,h_noise,~]=lms_adaptive_identification(x_noise,d_noise,M,mu,gamma,2);



%% rysunki

figure('Name','Identyfikacja odpowiedzi impulsowej','NumberTitle','off');

subplot(2,1,1);
plot(0:L-1, h_true, 'k', 'LineWidth', 1.5); hold on;
plot(0:L-1, h_mowa, 'b--');
title('Identyfikacja z sygnałem mowy');
xlabel('Indeks próbki'); ylabel('Amplituda');
legend('Odpowiedź rzeczywista', 'Estymowana (mowa)');

subplot(2,1,2);
plot(0:L-1, h_true, 'k', 'LineWidth', 1.5); hold on;
plot(0:L-1, h_noise, 'r--');
title('Identyfikacja z szumem białym');
xlabel('Indeks próbki'); ylabel('Amplituda');
legend('Odpowiedź rzeczywista', 'Estymowana (szum)');

