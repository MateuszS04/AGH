% Podział pomieszczenia na sektory 1x1 m
sector_dim = 1;
num_x_sectors = x_dim / sector_dim;
num_y_sectors = y_dim / sector_dim;

% Algorytm lokalizacji pasywnej
% Zakładamy, że znamy położenie zablokowanych promieni (wykrycie z ćwiczenia 1)

% Tworzenie macierzy sektorów (na początku zakładamy, że wszystkie sektory są potencjalne)
sectors = ones(num_x_sectors, num_y_sectors);

for k = 1:size(passive_object, 1)
    % Resetowanie sektorów przy każdej iteracji
    sectors = ones(num_x_sectors, num_y_sectors);

    for i = 1:size(tx_coords, 1)
        for j = 1:size(rx_coords, 1)
            if czyZablokowane(tx_coords(i, :), rx_coords(j, :), passive_object(k, :), obj_dim)
                % Znajdź sektory przez które przechodzi zablokowany promień
                [intersecting_sectors, ~] = wektorsektor(tx_coords(i, :), rx_coords(j, :), sector_dim);
                for m = 1:size(intersecting_sectors, 1)
                    sectors(intersecting_sectors(m, 1), intersecting_sectors(m, 2)) = sectors(intersecting_sectors(m, 1), intersecting_sectors(m, 2)) + 1;
                end
            end
        end
    end

    % Rysowanie sektorów
    figure;
    hold on;
    axis([0 x_dim 0 y_dim]);
    grid on;
    for i = 1:num_x_sectors
        for j = 1:num_y_sectors
            if sectors(i, j) == max(sectors(:))
                rectangle('Position', [i - 1, j - 1, sector_dim, sector_dim], 'EdgeColor', 'b', 'FaceColor', 'g', 'LineWidth', 1);
            end
        end
    end
    hold off;
end

function [intersecting_sectors, num_sectors] = wektorsektor(tx, rx, sector_dim)
    % Funkcja sprawdzająca przez które sektory przechodzi promień
    x1 = tx(1);
    y1 = tx(2);
    x2 = rx(1);
    y2 = rx(2);
    intersecting_sectors = [];
    num_sectors = 0;

    % Sprawdzanie sektorów przez które przechodzi promień (proste sprawdzenie dla każdego sektora)
    for i = 1:x_dim / sector_dim
        for j = 1:y_dim / sector_dim
            sector_x = (i - 1) * sector_dim;
            sector_y = (j - 1) * sector_dim;
            [in, on] = inpolygon((x1 + x2) / 2, (y1 + y2) / 2, [sector_x, sector_x + sector_dim, sector_x + sector_dim, sector_x], [sector_y, sector_y, sector_y + sector_dim, sector_y + sector_dim]);
            if in || on
                intersecting_sectors = [intersecting_sectors; i, j];
                num_sectors = num_sectors + 1;
            end
        end
    end
end
