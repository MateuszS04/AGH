

x=linspace(-1,1,1000);
n=10;
C=cheb_poly(n,x);

figure;
hold on;
for i=1:n+1
    plot (x,C(i,:),'DisplayName',['C_',num2str(i-1),'x'])
end

title('Wielomiany czebyszewa');
xlabel('x');
ylabel('y');
legend show;
grid on;

function C=cheb_poly(n,x)
%tablica do przetrzymywania wielomianów

    C=zeros(n+1,length(x));
    C(1,:)=1;
    C(2,:)=x;
    for i=2:n
        C(i+1,:)=2*x.*C(i,:)-C(i-1,:);
    end
end