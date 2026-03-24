
x = [0, 1, 2, 3, 4]; % przykładowe dane
y = [1, 2, 0, 2, 1]; 
N = length(x);%liczba punktów


h = diff(x);%oblicza różnicę między kolejnymi elementami wektora x, odległości między kolejnymi punktami

%układ równań
A = zeros(N, N); % współczynniki
b = zeros(N, 1); % wektor prawej strony

%wypełniamy układ równań
A(1, 1) = 1;%dla warunków brzegowych ustalamy 1, wartości te odpowiadają pierwszym i ostatnim współczynnikom drógiej pochodnej funkcji interpolowanej
A(N, N) = 1;%warunke naturalny

% Warunke ciągłości dla drugich pochodnych
for i = 2:N-1
    A(i, i-1) = h(i-1);
    A(i, i) = 2 * (h(i-1) + h(i));
    A(i, i+1) = h(i);
    b(i) = 3 * ((y(i+1) - y(i)) / h(i) - (y(i) - y(i-1)) / h(i-1));
end

% Rozwiązujemy układ równań
M = A \ b;

% Obliczmy współczynniki wielomianów kubicznych dla każdego przedziału x
for i = 1:N-1
    a(i) = y(i);
    b(i) = (y(i+1) - y(i)) / h(i) - h(i) * (2 * M(i) + M(i+1)) / 3;
    c(i) = M(i);
    d(i) = (M(i+1) - M(i)) / (3 * h(i));
end

%wyświetlamy współczynniki 
disp('Cubic spline coefficients:');
for i = 1:N-1
    fprintf('Interval %d: S(x) = %.4f + %.4f*(x - %.1f) + %.4f*(x - %.1f)^2 + %.4f*(x - %.1f)^3\n', ...
            i, a(i), b(i), x(i), c(i), x(i), d(i), x(i));
end
