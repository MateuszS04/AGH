% svd_image.m
clear all; close all;
[X,map] = imread('lena512.bmp'); % wczytaj obraz
wymiary = size(X),
X = double(X); % pokaz go
image(X); 
title('Oryginal');
colormap(map); 
axis image off; pause
[U,S,V] = svd(X); % zrob dekompozycje SVD
image( U*S*V' ); 
title('SVD'); % odtworz obraz ze wszystkich skladowych
colormap(map); axis image off; pause
mv=[1, 2, 3, 4, 5, 10, 15, 20, 25, 50]; % okresl liczbe skladowych
for i = 1:length(mv) % PETLA - START
mv(i) % wybrana liczba skladowych
mask = zeros( size(S) ); % maska zerujaca wartosci osobliwe (w.o.)
mask( 1:mv(i), 1:mv(i) ) = 1; % wstaw "1" pozostawiajace najwieksze w.o.
figure; 
image( U*(S.*mask)*V' ); % synteza i pokaznie obrazu zrekonstruowanego
colormap(map); 
axis image off; % bez osi
 % a widzisz?
end

errors=zeros(1,length(mv));
for i =1:length(mv)
    mask=zeros(size(S));
    mask(1:mv(i),mv(i))=1;
    recon=U*(S.*mask)*V;
    errors=mean(mean(abs(X-recon)));
end
figure;
plot(mv,errors,'r');
title('średni błąd odtworzenia')