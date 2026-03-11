% Parametry pomieszczenia
room_x = 16; % szerokość pokoju [m]
room_y = 28; % wysokość pokoju [m]
partition_y = 20.05; % współrzędna y dla ściany działowej
door_start_x = 10; % początek drzwi
door_end_x = 13; % koniec drzwi

% Pozycja nadajnika
tx_pos = [12.05, 7.05]; % współrzędne nadajnika [m]

% Moc nadajnika [mW]
tx_power = 5; % moc nadajnika [mW]

% Parametry propagacji
freq = 3.6e9; % częstotliwość [Hz]
lambda = 3e8 / freq; % długość fali [m]

% Współczynnik odbicia ścian
reflection_coeff = 0.7;

% Tworzenie siatki odbiorników (co 10 cm)
[x, y] = meshgrid(0:0.1:room_x, 0:0.1:room_y); 
[rows, cols] = size(x);

% Macierz mocy odbieranego sygnału
received_power = zeros(rows, cols);

% Funkcja sprawdzająca Line-of-Sight
function los = check_line_of_sight(tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
    % Sprawdzanie, czy linia przecina ścianę działową
    if rx_pos(2) > partition_y && tx_pos(2) < partition_y
        % Sprawdzenie, czy promień przechodzi przez drzwi
        x_intersect = tx_pos(1) + (rx_pos(1) - tx_pos(1)) * (partition_y - tx_pos(2)) / (rx_pos(2) - tx_pos(2));
        if x_intersect < door_start_x || x_intersect > door_end_x
            los = false; % Promień nie przechodzi przez drzwi
            return;
        end
    end
    los = true; % Line-of-Sight
end

% Obliczanie mocy sygnału (LoS)
for i = 1:rows
    for j = 1:cols
        rx_pos = [x(i,j), y(i,j)]; % pozycja odbiornika

        % Sprawdzenie, czy jest Line-of-Sight
        if check_line_of_sight(tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
            % Obliczanie odległości
            d = sqrt((tx_pos(1) - rx_pos(1))^2 + (tx_pos(2) - rx_pos(2))^2);
            
            % Obliczanie mocy odbieranej (tłumienie wolnej przestrzeni)
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j) = tx_power * path_loss;
        else
            received_power(i,j) = 0; % Brak LoS, brak sygnału
        end
    end
end

% Wyświetlanie mapy mocy sygnału (LoS)
figure;
pcolor(x, y, 10*log10(received_power)); % moc w skali logarytmicznej [dBm]
shading interp;
colorbar;
title('Mapa mocy sygnału w pomieszczeniu (LoS)');
xlabel('x [m]');
ylabel('y [m]');

% Dodawanie odbić (odbicia od lewej, prawej, dolnej i górnej ściany)
for i = 1:rows
    for j = 1:cols
        rx_pos = [x(i,j), y(i,j)];
        
        % Odbicie od lewej ściany
        mirror_tx_pos = [-tx_pos(1), tx_pos(2)];
        if check_line_of_sight(mirror_tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
            d = sqrt((mirror_tx_pos(1) - rx_pos(1))^2 + (mirror_tx_pos(2) - rx_pos(2))^2);
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j) = received_power(i,j) + tx_power * path_loss * reflection_coeff;
        end
        
        % Odbicie od prawej ściany
        mirror_tx_pos = [2 * room_x - tx_pos(1), tx_pos(2)];
        if check_line_of_sight(mirror_tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
            d = sqrt((mirror_tx_pos(1) - rx_pos(1))^2 + (mirror_tx_pos(2) - rx_pos(2))^2);
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j) = received_power(i,j) + tx_power * path_loss * reflection_coeff;
        end
        
        % Odbicie od dolnej ściany
        mirror_tx_pos = [tx_pos(1), -tx_pos(2)];
        if check_line_of_sight(mirror_tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
            d = sqrt((mirror_tx_pos(1) - rx_pos(1))^2 + (mirror_tx_pos(2) - rx_pos(2))^2);
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j) = received_power(i,j) + tx_power * path_loss * reflection_coeff;
        end
        
        % Odbicie od górnej ściany
        mirror_tx_pos = [tx_pos(1), 2 * room_y - tx_pos(2)];
        if check_line_of_sight(mirror_tx_pos, rx_pos, partition_y, door_start_x, door_end_x)
            d = sqrt((mirror_tx_pos(1) - rx_pos(1))^2 + (mirror_tx_pos(2) - rx_pos(2))^2);
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j) = received_power(i,j) + tx_power * path_loss * reflection_coeff;
        end
    end
end

% Wyświetlanie zaktualizowanej mapy mocy sygnału (z odbiciami)
figure;
pcolor(x, y, 10*log10(received_power)); % moc w skali logarytmicznej [dBm]
shading interp;
colorbar;
title('Mapa mocy sygnału z uwzględnieniem odbić');
xlabel('x [m]');
ylabel('y [m]');
