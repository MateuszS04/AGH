% test_rand.m
clear all; close all;
N=100000;
seed=123;
% r = rand_mult(N,seed); % multiplikatywny (ile liczb, pierwsza liczba)
r = rand_multadd(N,seed); % kongruentny
figure; plot(r,'bo'); 
figure; hist(r,20); 

%okres generowanych liczb
period=-1;% domyślnie brak okresu
for k=1:N-1%dla metody multiplikatywnej da się znaleźć okres liczb generowanych dla metody multiplikatywnej okres jest zbyt długi dla próbki
%danych, które zostaną przetworzone w sensownym czasie
    if all(r(1:N-k)==r(k+1:end))
        period=k;
        break
    end
end

fprintf('okres generowanej sekwencji: %d\n', period);


