% Parametry
f = 3e9;              % częstotliwość 3 GHz
c = 3e8;              % prędkość światła w m/s
lambda = c / f;       % długość fali
Pt = 5;               % moc stacji bazowej 5 W
v = 30;               % prędkość użytkownika w m/s
t_total = 6;          % czas obserwacji w sekundach
dt = 0.01;            % krok czasowy 10 ms
t = 0:dt:t_total;     % wektor czasu

% Pozycje początkowe
user_start = [50, 10];
user_end = [50, 300];
BS_pos = [110, 190];

% Pozycje ścian
wall1_start = [20, 30];
wall1_end = [20, 300];
wall2_start = [70, 100];
wall2_end = [130, 100];

reflection_coeff = 0.8;  % współczynnik odbicia

% Trajektoria użytkownika
user_positions = [user_start(1) * ones(size(t)); user_start(2) + v * t]';

% Prealokacja
Pr_direct = zeros(size(t));
Pr_reflected1 = zeros(size(t));
Pr_reflected2 = zeros(size(t));

% Funkcja liczenia odległości
distance = @(p1, p2) sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);

% Obliczenia mocy sygnału
for i = 1:length(t)
    % Pozycja użytkownika w danej chwili
    user_pos = user_positions(i, :);
    
    % Odległość bezpośrednia
    d_direct = distance(BS_pos, user_pos);
    Pr_direct(i) = Pt * (lambda / (4 * pi * d_direct))^2;
    
    % Odbicie od pierwszej ściany
    reflection_point1 = [wall1_start(1), user_pos(2)];  % punkt odbicia od ściany 1
    if reflection_point1(2) >= wall1_start(2) && reflection_point1(2) <= wall1_end(2)
        d_reflect1 = distance(BS_pos, reflection_point1) + distance(reflection_point1, user_pos);
        Pr_reflected1(i) = reflection_coeff * Pt * (lambda / (4 * pi * d_reflect1))^2;
    end
    
    % Odbicie od drugiej ściany
    reflection_point2 = [user_pos(1), wall2_start(2)];  % punkt odbicia od ściany 2
    if reflection_point2(1) >= wall2_start(1) && reflection_point2(1) <= wall2_end(1)
        d_reflect2 = distance(BS_pos, reflection_point2) + distance(reflection_point2, user_pos);
        Pr_reflected2(i) = reflection_coeff * Pt * (lambda / (4 * pi * d_reflect2))^2;
    end
end

% Całkowita moc sygnału
Pr_total = Pr_direct + Pr_reflected1 + Pr_reflected2;

% Wykres
figure;
plot(t, 10*log10(Pr_direct), 'b', 'DisplayName', 'Sygnał bezpośredni');
hold on;
plot(t, 10*log10(Pr_reflected1), 'r--', 'DisplayName', 'Odbicie od ściany 1');
plot(t, 10*log10(Pr_reflected2), 'g--', 'DisplayName', 'Odbicie od ściany 2');
plot(t, 10*log10(Pr_total), 'k', 'DisplayName', 'Sygnał całkowity');
xlabel('Czas [s]');
ylabel('Moc sygnału [dB]');
legend;
title('Moc sygnału odbieranego przez użytkownika');
grid on;
