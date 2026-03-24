[x,fs] = audioread( 'DontWorryBeHappy.wav');
x=x(:,1);
x=x/max(abs(x));
L=16;
a = 0.9545; % parametr a kodera
d = x - a*[ 0; x(1:end-1) ]; % KODER
dq = lab11_kwant( d,L ); % kwantyzator
% tutaj wstaw dekoder
% dq=d;


%% dekoder 
y=zeros(size(dq));
y(1)=dq(1);
for n=2:length(dq)
    y(n)=dq(n)+a*y(n-1);
end

%% rysunki

figure(1);
n = 1:length(x);

subplot(3,1,1);
plot(n, x, 'b');
xlabel('Numer próbki');
ylabel('Amplituda');
title('Oryginalny sygnał x(n)');
grid on;


subplot(3,1,2);
plot(n, y, 'r');
xlabel('Numer próbki');
ylabel('Amplituda');
title('Zrekonstruowany sygnał y(n)');
grid on;

subplot(3,1,3);
plot(n, x - y, 'k');
xlabel('Numer próbki');
ylabel('Amplituda');
title('Błąd rekonstrukcji: x(n) - y(n)');
grid on;


mse = mean((x - y).^2);
fprintf('MSE po kwantyzacji (4 bity, 16 poziomów): %.4f\n', mse);


% soundsc(y, fs);
%% zadanie dodatkowe
[x_2,fs_2] = audioread( 'DontWorryBeHappy.wav');
x_2=x_2(:,1);
x_2=x_2/max(abs(x_2));

bits=4;
L=2^bits;
a=0.95;
zmax=1;
zmin=0.001;
z=0.2*zmax;

%Tablice adaptacji określa jak zakres kwantyzatora z ma być modyfikowany na
%podstawie amplitudy zakodowanego błędu ind czyli adaptacja kwantyzatora
%zgodnie z G. 726
if L==4
    xm=[0.8,1.6];
elseif L==8
    xm=[0.9,0.9,1.25,1.75];
elseif L==16
    xm=[0.8, 0.8, 0.8, 0.8, 1.2, 1.6, 2.0, 2.4];
end
mp=2;
beta=0.01;%współczynnik uczenia (jak szybko ai ma się dostosowywać do zmian w sygnale)
ai=zeros(mp,1);%wektor współczynników predykcji liniowej
buf=zeros(mp,1);

N=length(x_2);
dq_2=zeros(N,1); %zakodowanie błędu 
y_2=zeros(N,1);
y_2(1)=x_2(1);

for n=mp+1:N
    %Koder
    pred=buf'*ai; %predykcja syganłu na podstawie poprzedniej próbki

    e=x_2(n)-pred; %obliczenie błędu predykcji 

    [ind,wy]=kwant_rown(L,z,e); %kwantyzacja różnicy 
    dq_2(n)=wy; %zapis zakodowanego błędu
    y_2(n)=wy+pred; %rekonstrukcja sygnału,dekodowanie

    ind_abs=max(1,min(abs(ind), length(xm))); %bezpieczny indeks
    z=z*xm(ind_abs); % adaptacja zakresu kwantyzatora 
    z=max(min(z,zmax),zmin); %ograniczenie zakresu

    ai=ai+beta*wy*buf; %adapatacja współczynnika predykcji
    buf=[y_2(n);buf(1:mp-1)];%uczenie się predyktor metodą LMS
    if norm(ai)>1e6
        break;
    end
end
mse_2=mean((x_2-y_2).^2); %błąd średniokwadratowy

fprintf('MSE: %.6f\n', mse_2);

n = 1:N;
figure;
subplot(3,1,1);
plot(n, x_2, 'b'); title('Oryginalny sygnał x(n)'); grid on;

subplot(3,1,2);
plot(n, y_2, 'r'); title('Zrekonstruowany sygnał y(n)'); grid on;

subplot(3,1,3);
plot(n, x_2 - y_2, 'k'); title('Błąd rekonstrukcji: x(n) - y(n)'); grid on;