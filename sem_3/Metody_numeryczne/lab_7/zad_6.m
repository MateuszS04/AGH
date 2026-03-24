clear all; close all;
[im1, map] = imread('lena512.bmp'); % Wczytaj obraz
figure; imshow(im1, map); title('Wejściowy obraz');

% Definicja masek filtrów z tabeli 7.3
filters = {
    'Sobel', {[1 2 1; 0 0 0; -1 -2 -1], [1 0 -1; 2 0 -2; 1 0 -1]};
    'Prewitt', {[1 1 1; 0 0 0; -1 -1 -1], [1 0 -1; 1 0 -1; 1 0 -1]};
    'Roberts', {[1 0; 0 -1], [0 1; -1 0]};
    'Skew', {[1 1 1; 1 -2 -1; 1 -1 -1], [1 1 1; -1 -2 1; -1 -1 1]};
    'Laplacian 1', { [0 -1 0; -1 4 -1; 0 -1 0]};
    'Laplacian 2', { [1 -2 1; -2 4 -2; 1 -2 1]};
    'Laplacian 3', { [-1 -1 -1; -1 8 -1; -1 -1 -1]};
    'Laplacian of Gaussian', {[0 0 1 0 0; 0 1 2 1 0; 1 2 -16 2 1; 0 1 2 1 0; 0 0 1 0 0]};
};


figure;
for i = 1:length(filters)
    % Wybór filtra i zastosowanie konwolucji
    filter_name = filters{i, 1};
    filter_masks = filters{i, 2};
    
    % Jeśli filtr ma więcej niż jedną maskę (dla Sobel, Prewitt, Roberts), zastosuj każdą maskę osobno
    if length(filter_masks) > 1
        filtered_image_x = conv2(double(im1), filter_masks{1}, 'same');
        filtered_image_y = conv2(double(im1), filter_masks{2}, 'same');
        im2 = sqrt(filtered_image_x.^2 + filtered_image_y.^2); % Połączenie filtrów w obu kierunkach
    else
        % Dla Laplasjanów wystarczy jedno przetworzenie
        im2 = conv2(double(im1), filter_masks{1}, 'same');
    end
    
    % Skalowanie nieliniowe 
    im2 = abs(im2); % Najpierw moduł, by pozbyć się wartości ujemnych
    im2 = im2 .^ 0.5; % Nieliniowe skalowanie dla poprawy wizualizacji
    
    % Wyświetlanie wyników
    subplot(3, 3, i);
    imshow(im2, []); % Użyj dynamicznego zakresu, aby wyświetlić pełen kontrast
    title(['Filtr: ', filter_name]);
end
