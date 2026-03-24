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
macierz_syntezy=macierz';

ident=isequal(round(macierz_syntezy*macierz),eye(N));%część w której sprawdzamy czy iloczyn macierzy daje macierz jednostkową-eye(n)
if ident
    disp('macierz jest ortonormalne')
else
    disp('nie jest')
end

x=randn(N,1);
x2=macierz*x;
x_odtworzone=macierz_syntezy*x2;
error=sum(abs(x_odtworzone-x)/N);
disp(error)

