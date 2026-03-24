%% Dane ogólne i do generowanie sygnału do punktu 1
fs=19200;
fpilot=19000;
phi=pi/4;
duration_1=1;


t_1=0:1/fs:duration_1-1/fs;


p=cos(2*pi*fpilot*t_1+phi);%nasz sygnał syntetyczny do przeanalizowania do pętli


%% punkt 1
[osc,theta]=PLL(p,fpilot,fs);

p_comper=cos(2*pi*3*fpilot*t_1+3*phi);

figure
% subplot(3,1,1)
plot(t_1(1:1000),p(1:1000),'DisplayName','Pilot 19kHz, przsunięcie phi=pi/4')
hold on
plot(t_1(1:1000),osc(1:1000),'r--','DisplayName','Oscylator adaptacujny');
hold on
plot(t_1(1:1000),p_comper(1:1000),'b--','DisplayName','Idealna 3 harmoniczna')
legend;
title('Porównanie sygnału pilota i oscylatora')
xlabel('Czas [s]')
ylabel('Amplituda')

%% punkt drugi z wolną zmianą częstotliwości pilot 10Hz
fm=0.1;
duration_2=20;
df=10;
t_2=0:1/fs:duration_2-1/fs;

freq_change=fpilot +df*sin(2*pi*fm*t_2); % Zmienna częstotliwość pilota: fpilot(t) = fpilot + df*sin(2*pi*fm*t)


phase_2=2*pi*cumsum(freq_change)/fs+phi;% Oblicz fazę przez całkowanie częstotliwości
p_2=cos(phase_2); % Sygnał pilota z modulacją częstotliwości


[osc_2,theta_2]=PLL(p_2,fpilot,fs);

phase_comp=2*pi*cumsum(freq_change)/fs+phi;
ideal_osc=cos(3*phase_2);
phase_error=angle(exp(1j*(phase_2-theta_2)));


figure;
plot(t_2(1:20000),p_2(1:20000),'DisplayName',"Sygnał z pilota po modulacji")
hold on
plot(t_2(1:20000),osc_2(1:20000),'r--','DisplayName','Oscylator PLL');
hold on
plot(t_2(1:20000),ideal_osc(1:20000),'b--','DisplayName','Idealny pscy;ator x3')
title('Pll z pilotem o zmiennej częstotliwości')
xlabel('czas')
ylabel('amplituda')

figure;
plot(t_2, phase_error);
xlabel('Czas [s]');
ylabel('Błąd fazy [rad]');
title('Różnica fazy między sygnałem pilota a oscylatorem PLL');

%% punkt 3 zbieżność pętli PLL
 AWGN_power=[0,5,10,20];
 samples=zeros(size(AWGN_power));
 threshold=0.1;
 duration_3=2;
 t_3=0:1/fs:duration_3-1/fs;


 phase_ref=2*pi*fpilot*t_1+phi;



 for i=1:length(AWGN_power)

     p_awg=awgn(p,AWGN_power(i),'measured'); %
     [osc_3,theta_3]=PLL(p_awg,fpilot,fs);

     phase_error_2=angle(exp(1j*(phase_ref-theta_3))); %porównanie fazy

     N_stable=1000;

     for n=1:length(phase_error_2)-N_stable    %PLL musi mieć stabilny błąd fazy przy 1000 próbek
         window=phase_error_2(n:n+N_stable-1);  % szukamy pierwszego momentu n od którego przez kolejne 1000 próbwek błąd fazy będzie stabilny<0.1
         if all(abs(window)<threshold)
             lock_sample(i)=n;% tutaj sapisujem ten moment od którego sygnał był stabilny
             break             %czyli sygnał złapał ten moment po tylu próbkach
         end
     end
    figure;% wykres błędu fazy
    plot(t_1, phase_error_2);
    yline(threshold, '--r');
    yline(-threshold, '--r');
    xlabel('Czas [s]');
    ylabel('Błąd fazy [rad]');
    title(['Błąd fazy PLL (Szum = ' num2str(AWGN_power(i)) ' dB)']);


 end


disp('szybkość znieżności PLL(liczba próbek)')
for i=1:length(AWGN_power)
    fprintf('Szum=%2d dB: %d próbek (%0.3f s)\n', AWGN_power(i),lock_sample(i), lock_sample(i)/fs)
end

