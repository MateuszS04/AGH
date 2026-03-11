% evd_elipsa.m
clear all; close all;
N = 1000;
% Elipsa - symetryczna macierz kowariancji elipsy
S = [ 3 1; ... % większe wartości tym większa elipsa 
1 3]; %macierz S jest symetryczna i określa elipsę Możemu zmienić wartości elementów 
% kierunki wektorów mają wpływ na nachylenie elipsy względem osi 
%szerokość elipsy jest  proporcjonalna do pierwiastków z wartości własnych
%macierzy
x = elipsa(S,1,N);
figure; plot(x(1,:),x(2,:), 'ro'); grid; hold on;
x = x .* (2*(rand(1,N)-0.5));
%x = x .* (0.33*(randn(1,N)));
plot(x(1,:),x(2,:), 'b*'); grid;
xlabel('x'); ylabel('y'); title('Circle/Ellipse'); grid; axis square





function x = elipsa(S,r,N)% generujemy pinkty na elipsoe gdzie S jest macierzą kowariancji r to promień a N to liczna punktów 
[V,D] = eig(S); % EVD
V = V*sqrt(r*D); % macierz transformacji y (okrag) --> x (elipsa)
alfa = linspace(0,2*pi,N); % katy okregu
x = V * [ cos(alfa); sin(alfa)]; % transformacja punktow okregu na elipse
%porównanie macierzy v z macierzą r, jak są identyczne to oznacza że V jest
%rotacją o kąt phi
phi = pi/4; % Kąt rotacji 45 stopni
R = [cos(phi) sin(phi); -sin(phi) cos(phi)];
disp('Macierz wektorów własnych V:');
disp(V);
disp('Macierz rotacji R:');
disp(R);
end