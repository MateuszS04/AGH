
close all; clear all;


N = 512; Nstep = 32;
[img, cmap] = imread('Lena512.bmp'); img = double(img); % Lena

% opcjonalna biala siatka
if(0)
    for i = Nstep:Nstep:N-Nstep
        img(i-1:i+1,1:N) = 255*ones(3,N);
    end
    for j = Nstep:Nstep:N-Nstep
        img(1:N,j-1:j+1) = 255*ones(N,3);
    end
end
imshow(img, cmap); pause;

% Dodawanie znieksztalcen beczkowych
a = [1.06, -0.0002, 0.000005]; % wspolczynniki wielomianu znieksztalcen
x = 1:N; y = 1:N;

% Automatyczne znajdowanie srodka deformacji
[cx, cy] = find_center_of_distortion(img);

[X, Y] = meshgrid(x, y); % wszystkie x, y
r = sqrt((X-cx).^2 + (Y-cy).^2); % wszystkie odleglosci od srodka
R = a(1)*r.^1 + a(2)*r.^2 + a(3)*r.^3; % zmiana odleglosci od srodka
Rn = R ./ r; % normowanie
imgR = interp2(img, (X-cx).*Rn+cx, (Y-cy).*Rn+cy); % interpolacja

figure;
subplot(1,2,1), imshow(img, cmap); title('Oryginal');
subplot(1,2,2), imshow(imgR, cmap); title('Rybie oko'); pause;

% Estymacja znieksztalcen beczkowych
i = Nstep : Nstep : N-Nstep; j = i; % polozenie linii w pionie i poziomie
[I, J] = meshgrid(i, j); % wszystkie (x, y) punktow przeciec

% Matching points in the distorted image
[distorted_points_x, distorted_points_y] = find_distorted_points(I, J, cx, cy, a);

% korekcja znieksztalcen beczkowych
[ainv, imgRR] = correct_barrel_distortion(imgR, cx, cy, x, y, a);

figure;
subplot(1,2,1), imshow(imgR, cmap); title('Wejscie - efekt rybie oko');
subplot(1,2,2), imshow(imgRR, cmap); title('Wyjscie - po korekcie');
colormap gray;
pause;

% Define functions to modularize the code

function [cx, cy] = find_center_of_distortion(img)
    % Function to find the center of distortion
    % Implement a method to find the center automatically
    % This is a placeholder implementation
    cx = size(img, 2) / 2 + 0.5;
    cy = size(img, 1) / 2 + 0.5;
end

function [distorted_points_x, distorted_points_y] = find_distorted_points(I, J, cx, cy, a)
    % Function to find the matching points in the distorted image
    r = sqrt((I-cx).^2 + (J-cy).^2); % wszystkie promienie od srodka
    R = a(1)*r + a(2)*r.^2 + a(3)*r.^3; % odpowiadajace punkty obrazu znieksztalconego
    distorted_points_x = (I - cx) .* (R ./ r) + cx;
    distorted_points_y = (J - cy) .* (R ./ r) + cy;
end

function [ainv, imgRR] = correct_barrel_distortion(imgR, cx, cy, x, y, a)
    % Function to correct barrel distortion
    r = 0:max(x)/2; % wybrane promienie
    R = polyval(a, r); % R=f(r) wielomianu znieksztalcen
    ainv = polyfit(R, r, 3); % wspolczynniki wielomiany odwrotnego

    [X, Y] = meshgrid(x, y); % wszystkie punkty (x,y) znieksztalconego
    R = sqrt((X-cx).^2 + (Y-cy).^2); % wszystkie zle promienie
    Rr = polyval(ainv, R); % wszystkie dobre promienie
    Rn = Rr ./ R; % normowanie
    imgRR = interp2(imgR, (X-cx).*Rn+cx, (Y-cy).*Rn+cy); % interpolacja
end
