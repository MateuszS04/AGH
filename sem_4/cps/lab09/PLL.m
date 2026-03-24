function [oscilator,theta_out] = PLL(p,fpilot,fs)

freq = 2*pi*fpilot/fs; %parametry algorytmu śledzenia 
theta = zeros(1,length(p)+1);
alpha = 1e-2;
beta = alpha^2/4;

for n = 1 : length(p) %% adaptacyna pętla śledzenia 
    perr = -p(n)*sin(theta(n)); %błąd fazy
    theta(n+1) = theta(n) + freq + alpha*perr;%aktualizacja fazy
    freq = freq + beta*perr;%aktualizacja częstotliwości
end

oscilator = cos(3*theta(1:end-1));
theta_out=theta(1:end-1);
end
%Generator lokalnego oscylatora – trzykrotność fazy, czyli synchronizacja z 3× pilotem. 
% (Czasem stosowane w np. pilotach w DSB-SC).