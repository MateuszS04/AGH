function [nr, wy] = kwant_rown(L, z, we)
    % Kwantyzacja typu mid-riser: bez poziomu zerowego
    delta = 2 * z / L; %zakres kwantyzatora 
    nr = floor(we / delta); %zamienia wartości wejścia na indeks poziomu 
    nr = max(min(nr, L/2 - 1), -L/2); % ogranicz do [-L/2, L/2 - 1]
    wy = nr * delta + sign(nr) * delta / 2; %oblicza wartość kwantyzacji
end
