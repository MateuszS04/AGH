function [y,bps] = kodowanie_podpasmowe_dynamiczne(x,ch,q,~)
% KODOWANIE_PODPASMOWE jest uproszczona implementacja techniki kompresji
%   wykorzystujacej kwantowanie sygnalu w podpasmach. Sygnal jest
%   analizowany w zespole filtrow PQMF. Probki w podpasmach sa skalowane
%   i kwantowane skalarnym kwantyzatorem rownomiernym.
%
%   Uwaga: zlozonosc obliczeniowa maleje z rosnaca liczba podpasm!!
%                 
%   [y,bps] = kodowanie_podpasmowe(x,n_ch,q,sf)
%   
%   x:     wektor probek sygnalu wejsciowego
%   n_ch:  liczba podpasm
%   q:     liczba bitow na probke w kazdym podpasmie (stala wartosc lub
%          wektor o dlugosci <= n_ch)
%   sf:    wspolczynniki skalujace dla kazdego podpasma; pominiecie tego
%          parametru spowoduje automatyczna normalizacje w podpasmie,
%          wartosc skalarna a = skalowanie wspolczynnikiem a^m, gdzie
%          jest indeksem podpasma
%   y:     wektor probek zrekonstrukowanego sygnalu
%   bps:   szacowana srednia liczba bitow na probke

Nx=length(x);
x=x(:)';
if nargin<4 
    sf = [];
end

disp('Przygotowanie zespolu filtrow ...')
% Rozklad podpasmowy, (c) T.Zielinski
%------------------------------
% Parametry wejsciowe
  M=ch;     % liczba kanalow kosinusowych
  L=16*M;    % dlugosc filtra prototypowego
  MM=2*M;   % liczba kanalow zespolonych, rzad decymacji
  Lp=L/MM;  % dlugosc skladowych polifazowych = 8
  
  M2=2*M; M3=3*M; M4=4*M;
  j = 0 : Lp-1;

% Odpowiedz impulsowa p(n) filtru prototypowego (niestandardowa)
  p = prototyp(L); p = sqrt(M)*p; 
  for n = 1 : 2 : Lp-1
     p( n*MM+1 : n*MM+MM ) = -p( n*MM+1 : n*MM+MM );
  end

 ap = reshape(p,2*M,Lp);
 ap=ap';
 ap=[ap(1:Lp,1:M); ap(1:Lp,M+1:M2)];
  
%  Polifazowe macierze transformacji: analizy A i syntezy B
  m=0:M2-1;
  for k=0:M-1
     A(k+1,1:M2) = 2*cos((pi/M)*(k+0.5).*(m-M/2));  % analysis matrix
     B(k+1,1:M2) = 2*cos((pi/M)*(k+0.5).*(m+M/2));  % synthesis matrix
  end

% Analiza podpasmowa
disp('Analiza podpasmowa ...')
h_wbar = waitbar(0,'Rozklad sygnalu na podpasma', 'Name', 'Kodowanie podpasmowe');
K = floor(Nx/M); bx = zeros(1,L); 
for k = 1 : K
    waitbar(k/K,h_wbar);
    % zaladowanie M nowych probek do bufora
    bx = [ x(k*M:-1:(k-1)*M+1) bx(1:L-M) ];
    % analiza
    pbx=p.*bx;
    a=reshape(pbx,M2,Lp); % filtracja polifazowa
    u=sum(a');
    sb(:,k) = A*u';       % modulacja kosinusowa
end
close(h_wbar);

%------------------------------
% Skalowanie + kwantyzacja, (c) M.Bartkowiak
disp('Skalowanie i kwantowanie podpasm ...')
if isempty(sf)
    sf = 1./max(abs(sb'));
elseif length(sf) == 1
    sf = sf.^(1:M);    
elseif length(sf) < M
    sf(end+1:M) = sf(end);
elseif length(sf) > M
    sf = sf(1:M);
end
sf_1 = 1./sf;
sf = diag(sparse(sf));
sf_1 = diag(sparse(sf_1));

%% część z adaptacyjnym dobieraniem bitów na podstawie energii 
if isempty(q)
    E = sum( sb.^2, 2 );        % obliczanie energii w subpaśmie
    E_total = sum(E);
    E_rel = E / E_total;        % względna energia, udział energetyczny każdego pasma  

    bps_total = 6*M;             % tu możesz zmienić wartość, przydział bitów proporcjonalny do użytego pasma 

    q_bits = round( bps_total * E_rel );  % na tej podstawie przydzielamy liczbę bitów do każdego pasma proporcjonalnie do jego energii

    q_max_per_band = floor(bps_total/2); % ograniczenia liczby bitów na pasmo i zapewnienie conajmniej jednego bitu na pasmo
    q_bits( q_bits > q_max_per_band ) = q_max_per_band;

    q_bits( q_bits < 1 ) = 1;

    sum_q = sum(q_bits);    
    
    diff = abs(sum(q_bits) - bps_total); %sprawdzamy czy suma bitów przydzielonych na pasmo zgadza się z oczekiwanym bużetem
    while diff > 0
        [~, idx_min] = min(q_bits); 
        q_bits(idx_min) = q_bits(idx_min) + 1;

        diff = diff - 1;
    end
    
    q = q_bits;   % nadpisujemy q (wektor M×1: liczba bitów dla każdego subpasm)
    % Teraz w dalszej części kodu będzie traktowane dokładnie jak q wektor w wersji 'else'.
    disp(q);
end
    

% if isscalar(q)
%     q = 2^q;
%     sbq = fix(q * sf * sb); %realizujemy prosty kwantyzator liniowy zaokrąglając liczby
%     bits = ceil(log2(max(sbq')-min(sbq')));
%     bits = sum(max(bits,0))*size(sbq,2);    % obliczamy liczbę bitów potrzebną do kodowania każdej próbki 
%     sbq = full(sf_1 * sbq / q); %odwrotna transofrmacja 
% else
    q = 2.^q(:); % dla każdego pasma mamy różną liczbę kwantyzacji w każdym paśmie 
    if length(q) < M
        q(end+1:M) = q(end);
    elseif length(q) > M
        q = q(1:M);
    end
    qq = diag(sparse(q)); % to macierz diagonalna z wartościami q, umożliwia skalowanie dla każdego pasma 
    qq_1 = diag(sparse(1./q));
    sbq = fix(qq * sf * sb);% sf skaluje amplitudy, qq przelicza je na poziomie kwantyzacji
    bits = ceil(log2(max(sbq')-min(sbq')));% liczymy liczbę bitów i rekonstruujemy sygnał 
    bits = sum(max(bits,0))*size(sbq,2);    
    sbq = full(qq_1 * sf_1 * sbq);    

disp('Obliczenie liczby bitow ...')
bps = bits/Nx;


%------------------------------
%% Synteza podpasmowa, (c) T.Zielinski 
disp('Synteza podpasmowa ...')
h_wbar = waitbar(0,'Synteza sygnalu z podpasm', 'Name', 'Kodowanie podpasmowe');
K = floor(Nx/M); bv=zeros(1,2*L); y=[];
for k = 1 : K
    waitbar(k/K,h_wbar);
    v = B'*sbq(:,k);                            % demodulacja kosinusowa
    bv = [ v' bv(1:2*L-MM) ];                   % wstawienie do bufora
    abv = reshape(bv,M4,Lp);
    abv = abv';
    abv = [abv(:,1:M); abv(:,M3+1:M4)];
    ys = sum(ap.*abv);
    y = [ y ys ];
end
%y=y(121:end);
close(h_wbar);

y = y(:);
y(length(x)) = 0;
y(length(x)+1:end) = [];



%------------------------------
%  Approksymacja filtru prototypowego MPEG,  (c) T.Zielinski 
function p = prototyp(L)
a0=1; a(1)=-0.99998229; a(2)=0.99692250;
a(4)=1/sqrt(2); a(6)=sqrt(1-a(2)^2); a(7)=-sqrt(1-a(1)^2);
A=-( a0/2+a(1)+a(2)+a(3)+a(4)+a(6)+a(7) );
a(3)=A/2-sqrt(0.5-A^2/4); a(5)=-sqrt(1-a(3)^2);
n = 0:L-1; p = a0*ones(1,L);
for(k=1:7) p = p + 2*a(k)*cos(2*pi*k*n/L); end
p = p/L; p(1)=0;
   
   