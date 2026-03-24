clear all;
close all;
N=100;
fs=1000;

f1=50;
f2=100;
% % f2=105;
f3=150;
% f1 = f1 + 2.5;
% f2 = f2 + 2.5;
% f3 = f3 + 2.5;

A1=50;
A2=100;
A3=150;

t=0:1/fs:(N-1)/fs;

x=A1*sin(2*pi*t*f1) + A2*sin(2*pi*t*f2)+A3*sin(2*pi*t*f3);

figure;
plot(t,x,'b-o');
xlabel('czas [s]')
ylabel('amplituda')
grid on;

macierz_A=zeros(N,N);%tworzymy macierz do której będzie wpisywać nasze elementy

for k=0:N-1
    if k==0
        s=sqrt(1/N);
    else
        s=sqrt(2/N);
    end
    for n=0:N-1
        macierz_A(k+1,n+1)=s*cos(pi*(k/N)*(n+0.5));
    end
end

macierz_S=macierz_A';

% figure;
% for i = 1:N
%     clf; 
%     wiersz_A = macierz_A(i, :); % i-ty wiersz macierzy A
%     kolumna_S = macierz_S(:, i)'; % i-ta kolumna macierzy S (transponowana do wiersza)
% 
%     % Rysowanie wykresu
%     plot(wiersz_A, 'b-o', 'DisplayName', sprintf('Wiersz A(%d,:)', i)); hold on;
%     plot(kolumna_S, 'r-s', 'DisplayName', sprintf('Kolumna S(:,%d)', i));
%     legend;
%     xlabel('Indeks');
%     ylabel('Wartość');
%     title(sprintf('Wiersz A(%d,:) i kolumna S(:,%d)', i, i));
%     grid on;
%     pause(0.5); 
% end

y=macierz_A*x';
figure;
n_2=1:N;
stem(n_2,abs(y),'bo','MarkerFaceColor','g')
grid on;

f=(0:N-1)*(fs/(2*N));
figure;
stem(f, abs(y),'bo','MarkerFaceColor','b')
xlabel('częstotliwość')
ylabel('współczynniki dct');
grid on;

disp('Niezerowe spółczynniki')
for i=1:N
    if abs(y(i))>1
        fprintf('f = %.2f Hz, y = %.2f\n', f(i), abs(y(i)));
    end
end
xr=macierz_S*y;
error=mean(abs(xr-x(:)));


disp(['bład rekonstrukcji :', num2str(error)])
figure;
plot(t, x, 'b-o', 'DisplayName', 'Oryginalny sygnał'); hold on;
plot(t, xr, 'r--s', 'DisplayName', 'Zrekonstruowany sygnał');
legend;
xlabel('Czas [s]');
ylabel('Amplituda');
grid on;
title('Porównanie sygnału oryginalnego i zrekonstruowanego');