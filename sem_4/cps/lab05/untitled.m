clear all; close all;

% Zera i bieguny transmitancji

z = [-j*5 j*5 -j*15 j*15];
p = [-0.5-j*9.5 -0.5+j*9.5 -1+j*10 -1-j*10 -0.5+j*10.5 -0.5-j*10.5];

% Zespolona zmienna transformacji Laplace'a
% dla s=jw przechodzi w transformację Fouriera:

w = 0.1:0.1:20;

% Zapisz transmitancję (1) wykorzystując powyższe parametry.
bm = poly(z); %poly() zapis wielomianów zdefiniowanych przez zera
an = poly(p);

% Przedstaw zera i bieguny na płaszczyźnie zespolonej.
figure('Name', 'Zera i bieguny');
plot(real(z),imag(z),'ro',real(p),imag(p),'b*');
title('Zera i bieguny transmitancji');
legend('Zera transmitancji','Bieguny transmitancji');
xlabel('Re'); ylabel('Img'); grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H    = polyval(bm, j*w)./polyval(an, j*w);
Hlog = 20*log10(abs(H));

% W skali liniowej
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa');
subplot(1,2,1);
plot(w, abs(H),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]'); ylabel('H [j\omega]'); grid;

% W skali decybelowej
subplot(1,2,2);
plot(w, Hlog,'b');         % skala logarytmiczna
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
xlabel('\omega [rad/s]'); ylabel('H [j\omega]'); grid;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H2    = H./max(H);
Hlog2 = 20*log10(abs(H2));

% W skali liniowej modyfikacja
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa - modyfikacja');
subplot(1,2,1);
plot(w, abs(H2),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]'); ylabel('H [j\omega]'); ylim([0 2.5]); grid;


% W skali decybelowej modyfikacja
subplot(1,2,2);
hold on;
plot(w, Hlog2,'b');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
plot([0, 20], [-52.5 -52.5],'k');
xlabel('\omega [rad/s]'); ylabel('H [j\omega]'); grid; hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H3 = polyval(bm, j*w)./polyval(an, j*w);
Hp = atan(imag(H3)./real(H3));  % atan - Inverse tangent in radians

figure('Name','Charakterystyka fazowo-częstotliwościowa');
stem(w, Hp,'b') 
title('Charakterystyka fazowo-częstotliwościowa');
xlabel('Częstotliwośc znormalizowana [Hz]'); ylabel('Faza [rad]');

figure('Name','Faza H');
plot(phasez(H),'b');           % phazes - Phase response of digital filter
title('Faza H');