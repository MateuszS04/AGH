clear all; 
close all
% w1 = [ 0 0 1 0 0 0 0 0 ]; % Wektor 1
% w2 = [ 0 0 0 0 1 0 0 0 ]; % Wektor 2
% w12 = w1 .* w2; % Iloczyn odpowiadających sobie próbek
% prod1 = sum(w12); % ,,0'' oznacza że wektory są ortogonalne
% prod2 = dot( w1, w2 ); % w przestrzeni Euklidesowej
% prod3 = w1*w2'; % bezpośrednie obliczenie (mnożenie wektorowe)

N=20;
macierz=zeros(N,N);%tworzymy macierz do której będzie wpisywać nasze elementy

for k=0:N-1
    if k==0
        s=sqrt(1/N);
    else
        s=sqrt(2/N);
    end
    for n=0:N-1
        macierz(k+1,n+1)=s*cos(pi*(k/N)*(n+0.5));
    end
end
ortog=true;
for k=1:N
    for n=1:N
        iloczyn=abs(dot(macierz(k,:),macierz(n,:)));

        if iloczyn>1e-10 && k~=n
            fprintf('Wektory %d i%d nie są ortogonalne iloczyn %f\n', k, n, iloczyn)
            ortog=false;        
        elseif k==n && iloczyn-1>1e-10
            fprintf('wektor %d nie jest znormalizowany', k, iloczyn);
            ortog=false;
        end
    end
end
if ortog
    disp('wektory są do siebie orotonormlane ')
else 
    disp('wektory nie są do siebie orotonormlane')
end


