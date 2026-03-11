% Parametry obszaru i liczby robotów
num_robots = 90;
area_width = 80;
area_height = 70;
std_dev_error = 2;  % Odchylenie standardowe błędu AoA

% Położenie stacji referencyjnych (w rogach)
stations = [0, 0;
            area_width, 0;
            area_width, area_height;
            0, area_height];

% Generowanie losowych pozycji robotów
robot_positions = [rand(num_robots, 1) * area_width, rand(num_robots, 1) * area_height];

% Prealokacja wektorów na estymowane pozycje
estimated_positions = zeros(num_robots, 2);

% Symulacja estymacji pozycji dla każdego robota
for i = 1:num_robots
    % Pozycja aktualnego robota
    x_real = robot_positions(i, 1);
    y_real = robot_positions(i, 2);
    
    % Obliczanie rzeczywistych kątów do każdej stacji i dodanie błędu
    AoA_measurements = zeros(4, 1);
    for j = 1:4
        % Rzeczywisty kąt nadejścia
        dx = stations(j, 1) - x_real;
        dy = stations(j, 2) - y_real;
        true_angle = atand(dy / dx);
        
        % Estymowany kąt z błędem
        AoA_measurements(j) = true_angle + randn * std_dev_error;
    end
    
    % Formowanie macierzy dla algorytmu najmniejszych kwadratów
    A = [];
    b = [];
    for j = 1:4
        angle_rad = deg2rad(AoA_measurements(j));
        A = [A; -cos(angle_rad), -sin(angle_rad)];
        b = [b; -(stations(j, 1) * cos(angle_rad) + stations(j, 2) * sin(angle_rad))];
    end
    
    % Obliczanie estymowanej pozycji metodą najmniejszych kwadratów
    pos_estimate = inv(transpose(A) * A) * transpose(A) * b;
    estimated_positions(i, :) = pos_estimate;
end

% Obliczenie średniego błędu lokalizacji
errors = sqrt(sum((robot_positions - estimated_positions).^2, 2));
mean_error = mean(errors);

% Wizualizacja
figure;
hold on;
% Rysowanie obszaru
rectangle('Position', [0, 0, area_width, area_height], 'EdgeColor', 'k', 'LineWidth', 1);
% Rysowanie stacji referencyjnych
plot(stations(:,1), stations(:,2), 'bs', 'MarkerSize', 10, 'DisplayName', 'Stacje referencyjne');
% Rysowanie rzeczywistych pozycji robotów
plot(robot_positions(:,1), robot_positions(:,2), 'go', 'DisplayName', 'Prawdziwe pozycje');
% Rysowanie estymowanych pozycji robotów
plot(estimated_positions(:,1), estimated_positions(:,2), 'rx', 'DisplayName', 'Estymowane pozycje');
legend('Location', 'Best');
title(['Średni błąd lokalizacji: ', num2str(mean_error, '%.2f'), ' m']);
xlabel('X [m]');
ylabel('Y [m]');
grid on;
hold off;
