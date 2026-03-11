% rand_transform1.m
% R[0,1) --> Dowolny rozklad o zadanej dystrybuancie
% F(x) = 1-exp(-lamb*x) = r --> x=?
%dystrybuanta F(x)
x = 0 : 0.01 : 3;
lamb = 1; 
F = 1-exp(-lamb*x);
plot( x, F ); 
xlabel('x'); 
ylabel('r'); 
title('F(x)'); 
grid; 
%Generowanie liczb losowych
disp('Rownomierny R[0,1) --> o dowolnej dystrybuancie');
N = 10000;
lamb = 2;
r = rand(1,N);
x = - (1/lamb)*log(1 - r);
figure;

subplot(221); 
plot(r,'b.'); 
title('liczby losowe r')
subplot(222); 
hist(r,20);
title('histogram r')
subplot(223); 
plot(x,'b.'); 
title('liczby losowe x z rozkładu wykładniczego')
subplot(224); 
hist(x,20); 
title('histogram x z rozkładu wykłaniczego')