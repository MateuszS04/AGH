
K1 = 10;  % reguły trapezów
K2 = 11;  % reguły Simpsona (musi być nieparzysta)
K3 = 10;  % reguły Simpsona 3/8 (musi być 3n + 1)
K4 = 13;  % reguły Boole’a (musi być wielokrotność 4 plus 1)

% Definiowanie przedziału
a = 0;
b = pi/2;

 
% reguła trapezów
x1 = linspace(a, b, K1);
y1 = sin(x1);
h1 = (b - a) / (K1 - 1);
I_trapez = h1/2 * (y1(1) + 2*sum(y1(2:end-1)) + y1(end));

% reguła Simpsona (II)
x2 = linspace(a, b, K2);
y2 = sin(x2);
h2 = (b - a) / (K2 - 1);
I_simpson = h2/3 * (y2(1) + 4*sum(y2(2:2:end-1)) + 2*sum(y2(3:2:end-2)) + y2(end));

% reguła Simpsona 3/8 (III)
x3 = linspace(a, b, K3);
y3 = sin(x3);
h3 = (b - a) / (K3 - 1);
I_simpson38 = 3*h3/8 * (y3(1) + 3*sum(y3(2:3:end-1)) + 3*sum(y3(3:3:end-1)) + 2*sum(y3(4:3:end-2)) + y3(end));

% 4. Reguła Boole’a (IV)
x4 = linspace(a, b, K4);
y4 = sin(x4);
h4 = (b - a) / (K4 - 1);
I_boole = 2*h4/45 * (7*y4(1) + 32*sum(y4(2:4:end-1)) + 12*sum(y4(3:4:end-1)) + 32*sum(y4(4:4:end-1)) + 14*sum(y4(5:4:end-2)) + y4(end));


disp(['Całka (reguła trapezów): ', num2str(I_trapez)]);
disp(['Całka (reguła Simpsona): ', num2str(I_simpson)]);
disp(['Całka (reguła Simpsona 3/8): ', num2str(I_simpson38)]);
disp(['Całka (reguła Boole’a): ', num2str(I_boole)]);


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
