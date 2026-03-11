clear all; close all;
[X,map] = imread('lena512.bmp'); % Wczytaj obraz
if size(X, 3) == 1
    % Obraz w skali szarości
    X = double(X); % Konwersja na double
    [U,S,V] = svd(X); % SVD
    wymiary = size(X)
    figure; image(X); title('Oryginal'); colormap(map); axis image off; pause
    figure; image(U*S*V'); title('SVD'); colormap(map); axis image off; pause
    mv = [1, 2, 3, 4, 5, 10, 15, 20, 25, 50];
    for i = 1:length(mv)
        mask = zeros(size(S)); % Maska zerująca
        mask(1:mv(i), 1:mv(i)) = 1; % Największe wartości osobliwe
        figure; image(U*(S.*mask)*V'); % Synteza i pokazanie obrazu
        colormap(map); axis image off;
        title(['Liczba składowych: ', num2str(mv(i))]);
        pause
    end
else
    % Obraz kolorowy
    X = double(X);
    R = X(:,:,1);
    G = X(:,:,2);
    B = X(:,:,3);
    [UR, SR, VR] = svd(R);
    [UG, SG, VG] = svd(G);
    [UB, SB, VB] = svd(B);
    
    wymiary = size(X)
    figure; image(uint8(X)); title('Oryginal'); axis image off; pause
    figure; 
    subplot(1,3,1); image(uint8(UR*SR*VR')); title('SVD - R'); axis image off;
    subplot(1,3,2); image(uint8(UG*SG*VG')); title('SVD - G'); axis image off;
    subplot(1,3,3); image(uint8(UB*SB*VB')); title('SVD - B'); axis image off;
    pause
    
    mv = [1, 2, 3, 4, 5, 10, 15, 20, 25, 50];
    for i = 1:length(mv)
        maskR = zeros(size(SR)); maskG = zeros(size(SG)); maskB = zeros(size(SB));
        maskR(1:mv(i), 1:mv(i)) = 1;
        maskG(1:mv(i), 1:mv(i)) = 1;
        maskB(1:mv(i), 1:mv(i)) = 1;
        reconR = UR * (SR .* maskR) * VR';
        reconG = UG * (SG .* maskG) * VG';
        reconB = UB * (SB .* maskB) * VB';
        reconX = cat(3, reconR, reconG, reconB);
        figure; image(uint8(reconX)); title(['Liczba składowych: ', num2str(mv(i))]);
        axis image off;
        pause
    end
end

% Wykres wartości osobliwych
figure; semilogy(diag(S), 'b'); title('Wartości osobliwe - skala szarości');
xlabel('Numer wartości osobliwej'); ylabel('Wartość osobliwa');

% Obliczenie średniego błędu odtworzenia
errors = zeros(1, length(mv));
for i = 1:length(mv)
    mask = zeros(size(S));
    mask(1:mv(i), 1:mv(i)) = 1;
    recon = U * (S .* mask) * V';
    errors(i) = mean(mean(abs(X - recon)));
end
figure; plot(mv, errors, 'r'); title('Średni błąd odtworzenia - skala szarości');
xlabel('Liczba składowych'); ylabel('Średni błąd');

% Modyfikacje dla obrazów kolorowych (wykresy dla każdego kanału osobno)
if size(X, 3) == 3
    figure; 
    subplot(1,3,1); semilogy(diag(SR), 'r'); title('Wartości osobliwe - R');
    xlabel('Numer wartości osobliwej'); ylabel('Wartość osobliwa');
    subplot(1,3,2); semilogy(diag(SG), 'g'); title('Wartości osobliwe - G');
    xlabel('Numer wartości osobliwej'); ylabel('Wartość osobliwa');
    subplot(1,3,3); semilogy(diag(SB), 'b'); title('Wartości osobliwe - B');
    xlabel('Numer wartości osobliwej'); ylabel('Wartość osobliwa');
    
    errorsR = zeros(1, length(mv));
    errorsG = zeros(1, length(mv));
    errorsB = zeros(1, length(mv));
    for i = 1:length(mv)
        maskR = zeros(size(SR)); maskG = zeros(size(SG)); maskB = zeros(size(SB));
        maskR(1:mv(i), 1:mv(i)) = 1;
        maskG(1:mv(i), 1:mv(i)) = 1;
        maskB(1:mv(i), 1:mv(i)) = 1;
        reconR = UR * (SR .* maskR) * VR';
        reconG = UG * (SG .* maskG) * VG';
        reconB = UB * (SB .* maskB) * VB';
        errorsR(i) = mean(mean(abs(R - reconR)));
        errorsG(i) = mean(mean(abs(G - reconG)));
        errorsB(i) = mean(mean(abs(B - reconB)));
    end
    figure; 
    subplot(1,3,1); plot(mv, errorsR, 'r'); title('Średni błąd odtworzenia - R');
    xlabel('Liczba składowych'); ylabel('Średni błąd');
    subplot(1,3,2); plot(mv, errorsG, 'g'); title('Średni błąd odtworzenia - G');
    xlabel('Liczba składowych'); ylabel('Średni błąd');
    subplot(1,3,3); plot(mv, errorsB, 'b'); title('Średni błąd odtworzenia - B');
    xlabel('Liczba składowych'); ylabel('Średni błąd');
end
