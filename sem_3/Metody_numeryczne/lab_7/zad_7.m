%minimalna liczba węzłów dla każdej metody
K1 = 2;  % dla reguły trapezów
K2 = 3;  % dla reguły Simpsona (II)
K3 = 4;  % dla reguły Simpsona 3/8
K4 = 5;  % dla reguły Boole’a

% Definiowanie przedziału
a = 0;
b = pi/2;


% reguła trapezów
x1 = linspace(a, b, K1);
y1 = sin(x1);
h1 = (b - a) / (K1 - 1);
I_trapez = h1/2 * (y1(1) + y1(end));

% reguła Simpsona (II)
x2 = linspace(a, b, K2);
y2 = sin(x2);
h2 = (b - a) / (K2 - 1);
I_simpson = h2/3 * (y2(1) + 4*y2(2) + y2(3));

% 3. Reguła Simpsona 3/8 (III)
x3 = linspace(a, b, K3);
y3 = sin(x3);
h3 = (b - a) / (K3 - 1);
I_simpson38 = 3*h3/8 * (y3(1) + 3*y3(2) + 3*y3(3) + y3(4));

% 4. Reguła Boole’a (IV)
x4 = linspace(a, b, K4);
y4 = sin(x4);
h4 = (b - a) / (K4 - 1);
I_boole = 2*h4/45 * (7*y4(1) + 32*y4(2) + 12*y4(3) + 32*y4(4) + 7*y4(5));

% Wyświetlanie wyników
disp(['Całka (reguła trapezów): ', num2str(I_trapez)]);
disp(['Całka (reguła Simpsona): ', num2str(I_simpson)]);
disp(['Całka (reguła Simpsona 3/8): ', num2str(I_simpson38)]);
disp(['Całka (reguła Boole’a): ', num2str(I_boole)]);

% Dokładna wartość całki
I_exact = 1;
disp(['Dokładna wartość całki: ', num2str(I_exact)]);

% Obliczanie błędów
error_trapez = abs(I_exact - I_trapez);
error_simpson = abs(I_exact - I_simpson);
error_simpson38 = abs(I_exact - I_simpson38);
error_boole = abs(I_exact - I_boole);

disp(['Błąd (reguła trapezów): ', num2str(error_trapez)]);
disp(['Błąd (reguła Simpsona): ', num2str(error_simpson)]);
disp(['Błąd (reguła Simpsona 3/8): ', num2str(error_simpson38)]);
disp(['Błąd (reguła Boole’a): ', num2str(error_boole)]);


