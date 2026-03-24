function y = dekodowanie_podpasmowe_dynamiczne(sbq, ch, q_dyn)
% sbq - zakodowane próbki podpasmowe (z kwantyzacją)
% ch - liczba kanałów / podpasm
% q_dyn - macierz [M x K], liczba bitów dla każdego podpasma w każdej ramce

% Przygotowanie filtrów PQMF — jak w koderze
% ... (część wspólna: filtr prototypowy, macierze A i B)

% Odtworzenie liczby ramek i podpasm
[M, K] = size(sbq);
L = 16 * ch;
Lp = L / (2 * ch);

% Skalowanie odwrotne i rekonstrukcja ramek
disp('Dekodowanie ramek z uwzględnieniem q_dyn ...')
sf=1./max(abs(sbq'),[],1); % użycie tej samej funkcji skalującej (uwaga!)
sf_1=1./sf;
sf=diag(sparse(sf));
sf_1=diag(sparse(sf_1));

sb_deq = zeros(M, K);
for k = 1:K
    qk = 2.^q_dyn(:,k);
    QQ = diag(sparse(qk));
    QQ_1 = diag(sparse(1 ./ qk));
    sb_deq(:,k) = full(QQ_1 * sf_1 * sbq(:,k));  % odwrotność kwantyzacji
end

% Synteza sygnału — dokładnie tak jak w koderze
disp('Synteza sygnału ...')
bv=zeros(1,2*L); y=[];
for k = 1 : K
    v = B'*sb_deq(:,k);
    bv = [ v' bv(1:2*L-2*ch) ];
    abv = reshape(bv,4*ch,Lp);
    abv = abv';
    abv = [abv(:,1:ch); abv(:,3*ch+1:4*ch)];
    ys = sum(ap.*abv);
    y = [ y ys ];
end

y = y(:);
