% Wymiary pomieszczenia
x_dim = 60;
y_dim = 40;

% Współrzędne nadajników (Tx)
tx_coords = [5.5, 4.5; 
             5.5, 20; 
             5.5, 34];

% Współrzędne odbiorników (Rx)
rx_coords = [54, 10.5; 
             54, 16.5; 
             54, 24.5; 
             54, 30.5];

% Rysowanie pomieszczenia
figure;
hold on;
axis([0 x_dim 0 y_dim]);
grid on;

% Rysowanie nadajników
for i = 1:size(tx_coords, 1)
    plot(tx_coords(i, 1), tx_coords(i, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
end

% Rysowanie odbiorników
for i = 1:size(rx_coords, 1)
    plot(rx_coords(i, 1), rx_coords(i, 2), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
end

% Rysowanie dróg LOS
for i = 1:size(tx_coords, 1)
    for j = 1:size(rx_coords, 1)
        line([tx_coords(i, 1), rx_coords(j, 1)], [tx_coords(i, 2), rx_coords(j, 2)], 'Color', 'g');
    end
end

% Definiowanie obiektu pasywnego (zmieniające się pozycje do testowania)
passive_object = [20, 15;  % przykład położenia obiektu 1
                  30, 25;  % przykład położenia obiektu 2
                  45, 5];  % przykład położenia obiektu 3

% Wymiary obiektu pasywnego
obj_dim = 1;

for k = 1:size(passive_object, 1)
    % Rysowanie obiektu pasywnego
    rectangle('Position', [passive_object(k, 1), passive_object(k, 2), obj_dim, obj_dim], 'EdgeColor', 'r', 'FaceColor', 'r');

    % Sprawdzenie zablokowanych dróg LOS
    for i = 1:size(tx_coords, 1)
        for j = 1:size(rx_coords, 1)
            if czyZablokowane(tx_coords(i, :), rx_coords(j, :), passive_object(k, :), obj_dim)
                line([tx_coords(i, 1), rx_coords(j, 1)], [tx_coords(i, 2), rx_coords(j, 2)], 'Color', 'r');
            else
                line([tx_coords(i, 1), rx_coords(j, 1)], [tx_coords(i, 2), rx_coords(j, 2)], 'Color', 'g');
            end
        end
    end
end

hold off;

function blocked = czyZablokowane(tx, rx, obj_pos, obj_dim)
    % Funkcja sprawdzająca czy promień jest zablokowany przez obiekt
    obj_x = [obj_pos(1), obj_pos(1) + obj_dim, obj_pos(1) + obj_dim, obj_pos(1)];
    obj_y = [obj_pos(2), obj_pos(2), obj_pos(2) + obj_dim, obj_pos(2) + obj_dim];
    [in, on] = inpolygon((tx(1) + rx(1)) / 2, (tx(2) + rx(2)) / 2, obj_x, obj_y);
    blocked = in || on;
end
