% rand_transform2.m
% Przeksztalcenie Boxa-Millera
disp('Rownomierny R[0,1) --> Normalny (0,1)')
N = 10000;
r1 = rand(1,N);
r2 = rand(1,N);
n1 = sqrt(-2*log(r1)) .* cos(2*pi*r2);
n2 = sqrt(-2*log(r1)) .* sin(2*pi*r2);
%Parametry nowego rozkładu
mu=5;
sigma=3;
%Przekształcamy na N(mu,sigma^2)
x1=sigma*n1+mu;
x2=sigma*n2+mu;



% 
% figure;
% subplot(111); 
% plot(n1,n2,'b*'); 
% figure;
% subplot(211); hist(n1,20); 
% title('n1');
% subplot(212); hist(n2,20); 
% title('n2'); 

% Wizualizacja
figure;
subplot(111); 
plot(x1, x2, 'r.'); 
title(['Rozkład normalny N(', num2str(mu), ', ', num2str(sigma^2), ')']);
xlabel('x1'); ylabel('x2');
grid on;

figure;
subplot(211); 
histogram(x1, 20, 'FaceColor', 'g'); 
title(['Histogram x1: N(', num2str(mu), ', ', num2str(sigma^2), ')']);
xlabel('x1'); ylabel('Częstotliwość');

subplot(212); 
histogram(x2, 20, 'FaceColor', 'm'); 
title(['Histogram x2: N(', num2str(mu), ', ', num2str(sigma^2), ')']);
xlabel('x2'); ylabel('Częstotliwość');