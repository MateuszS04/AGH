A = [2, -1;
     -3, 4;
     1, 1];

b = [1;
     0;
     2];

[Q,R]=qr(A);

Qt_b=Q'*b; %operacja przekształca wektor b na podstawie bazy wektora Q, transformuje b w nową przestrzeń współrzędnych

R1=R(1:size(A,2), :); %macierz trójkątna górna o wymiarach NxN
r2=Qt_b(1:size(A,2)); %wektor kolumnowy Nx1, wykorzystujemy do rozwiązania równania
r3=Qt_b(size(A,2)+1:end); %skalar, reszta z wektora b, której nie da się wyjaśnić przez Ax

x=R1\r2;

error=norm(r3)^2;%minimalizowany błąd dopasowania (długość wektora r3 to jego norma, suma kwadratów reszt)

disp("x ="+x)
disp("error ="+error)