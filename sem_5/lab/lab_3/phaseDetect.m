function [phErr] =  phaseDetect(error)
 rErr=real(error); %I - in-phace
 iErr=imag(error); %Q -quadrature
 
   if rErr < 0 % jeżeli I jest ujemne, lewa połowa układu
     phErr=-iErr; % to mamy -Q
   else % jeżeli I jest dodatnie to prawa połowa układu
     phErr=iErr; % mamy Q
   end
   
   if iErr < 0 % jeżeli Q jest ujemne to mamy dolną połowę
     phErr = real(phErr + rErr);
   else % jeżeli Q jest dodatnie to mamy górną połowę
     phErr = real(phErr - rErr);
   end
end 

% w idealny QPSK punkty konstelacji leżą w ćwiartkach I-Q.
% Tutaj określamy w której ćwiartce leży odebrany symbol
% generujemy błąd który przesunie fazę w stronę w kierunku najbliższego
% idealnego punktu sygnału QPSK