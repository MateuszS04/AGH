function rotated_matrix = jacobi_rotation(matrix)
    % sprawdzenie czy macierz jest symetryczna
    assert(isequal(matrix, matrix'));

    % pozyskanie rozmiaru macierzy
    [n, ~] = size(matrix);

    % ustawienie tolerancji poniżej, której elementy poza przekątną są
    % uznawane za zero
    tolerance = 1e-10;

    % pętla się wykonuje się do momentu gdy wszytskie elementy poza
    % przekątną będą bliskie zeru
    while true
        % szukkanie największego elementu macierzy poza przekątną 
        max_val = 0;
        p = 0;% p i q indeksy elementów największych poza przekątną
        q = 0;
        for i = 1:n-1
            for j = i+1:n
                if abs(matrix(i, j)) > max_val
                    max_val = abs(matrix(i, j));
                    p = i;
                    q = j;
                end
            end
        end

        % jeśli największy element poza przekątną jest mniejszy niż wartość
        % tolerancyjna to pętla się kończy
        if max_val<tolerance
            break;
        end

        % obliczanie kąta rotacji 
        if matrix(p, p) == matrix(q, q)
            alpha = pi/4;
        else
            alpha = 0.5 * atan2(2 * matrix(p, q), matrix(p, p) - matrix(q, q));
        end

        % tworzenie macierzy rotacji
        J = eye(n);%tworzenie macierzy jednostkowej(macierz nxn, na przekątnej są same 1)
        J(p, p) = cos(alpha);
        J(q, q) = cos(alpha);
        J(p, q) = -sin(alpha);
        J(q, p) = sin(alpha);
        disp('macierz rotacji ')
        disp(J);

        % macierz jest transformowana za pomocą rotacji
        matrix = J' * matrix * J;
    end

    %przekształcona macierz
    rotated_matrix = matrix;
end


%testowanie z macierzą 4x4
% A = [4, 1, 2, 3;
%      1, 2, 3, 4;
%      2, 3, 4, 1;
%      3, 4, 1, 2];


A=[ 2,0,1;
    0,-2,0;
    1,0,2];

%sprawdzenie czy macierz jest symetryczna
A = (A + A') / 2;


result = jacobi_rotation(A);


disp('orginalna macierz');
disp(A);
disp('przekształcona');
disp(result);
