%rozwiązanie prostego nadokreślonego układu równań  z definicji
A = [2, 1;
     4, 3;
     3, 2;
     5,4;
     6,2];

b = [5;
     11;
     8;
     7;
     2];

AtA = A' * A;%transponowanie macierzy a pomnożona przez macierz A

Atb = A' * b;%transpownowana macierz A mnożona przez macierz b

%wzór 6.1
x = inv(AtA) * Atb; %odwracamy macierz Ata i mnożymy przez ATB

disp(x);
