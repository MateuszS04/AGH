close all; clear all;
% Generacja/wczyranie obrazka
N = 512; Nstep = 32;
[img, cmap] = imread('Lena512.bmp'); img = double(img); % Lena
%img = zeros(N,N); % czarny kwadrat
if(0) % opcjonalna biała siatka
    for i = Nstep:Nstep:N-Nstep
        img(i-1:i+1, 1:N) = 255 * ones(3, N);
    end
    for j = Nstep:Nstep:N-Nstep
        img(1:N, j-1:j+1) = 255 * ones(N, 3);
    end
end
imshow(img, cmap); 

% Dodawanie zniekształceń beczkowych
a = [ 1.06, -0.0002, 0.000005 ]; % wspólczynniki wielomianu zniekształceń
x = 1:N; y = 1:N;
cx = N / 2 + 0.5; 
cy = N / 2 + 0.5; % Środek deformacji, obecnie na środku obrazu

%Estymacja zniekształceń beczkowych
[X, Y] = meshgrid(x, y); % wszystkie (x,y)
r = sqrt((X - cx).^2 + (Y - cy).^2); % wszystkie odległości od środka
R = a(1) * r.^1 + a(2) * r.^2 + a(3) * r.^3; % Zmiana odległości od środka
Rn = R ./ r; % Normalizacja
imgR = interp2(img, (X - cx) .* Rn + cx, (Y - cy) .* Rn + cy); % Interpolacja
figure;
subplot(1, 2, 1), imshow(img, cmap); title('Oryginal');
subplot(1, 2, 2), imshow(imgR, cmap); title('Rybie oko'); 


% Wykorzystanie siatki do oszacowania parametrów zniekształceń beczkowych
% na podstawie siatki punktów przecięć lini w obrazie
i = Nstep:Nstep:N - Nstep; j = i; % Położenie linii w pionie i poziomie
[I, J] = meshgrid(i, j); % punkty przecięcia lini
r = sqrt((I - cx).^2 + (J - cy).^2); % odległości każdego punktu od środka obrazu
R = a(1) * r + a(2) * r.^2 + a(3) * r.^3; % Zniekształcone punkty obrazu
r = sort(r(:)); % Sortowanie
R = sort(R(:)); % Sortowanie
aest1 = pinv([r.^1, r.^2, r.^3]) * R; aest1 = [aest1(end:-1:1); 0]; % rozwiązujemy układ równań pinv(odwrotność macierzy
aest2 = polyfit(r, R, 3)'; % dopasowujemy wielomian 3 stopnia do danych przy pomocy funkcji polyfit
[aest1, aest2],  % Porównanie
aest = aest1; % Czemu wybbieramy aest1?

% Aby doprowadzić do korekty musimy obliczyć odwrotność wielomianu f(r)
r = 0:N / 2; % wybrane promienie dlaczego takie?
R = polyval(aest, r); % R=f(r) wielomianu zniekształceń
figure; subplot(121); plot(r, R), title('R=f(r)');
ainv = polyfit(R, r, 3); % współczynniki wielomianu odwrotnego
subplot(122); plot(R, r), title('r=g(R)'); 

% Korekta zniekształceń beczkowych (z automatycznym wykrywaniem środka)
[X, Y] = meshgrid(x, y); %punkty zniekształconego obrazu
R = sqrt((X - cx).^2 + (Y - cy).^2); % oblicznie promieni zniekształconych
Rr = polyval(ainv, R); % obliczeni promieni poprawnych (odwrotność
Rn = Rr ./ R; % normalizacja, korygownaie zniekształceń
imgRR = interp2(imgR, (X - cx) .* Rn + cx, (Y - cy) .* Rn + cy); %interpolacja

figure;
subplot(1, 2, 1), imshow(imgR, cmap); title(' efekt rybie oko');
subplot(1, 2, 2), imshow(imgRR, cmap); title('po korekcie');
colormap gray

