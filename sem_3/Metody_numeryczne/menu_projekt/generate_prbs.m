% Funkcja generowania sekwencji PRBS w MATLAB
function prbs_sequence = generate_prbs(seq_length, initial_state)
    % Sprawdzenie, czy stan początkowy ma dokładnie 9 bitów
    if length(initial_state) ~= 9 || any(initial_state ~= 0 & initial_state ~= 1)
        error('Stan początkowy musi być wektorem 9 bitów (0 lub 1).');
    end

    % Inicjalizacja rejestru przesuwnego
    shift_register = initial_state;

    % Wyjściowa sekwencja PRBS
    prbs_sequence = zeros(1, seq_length);

    for i = 1:seq_length
        % Obliczenie sprzężenia zwrotnego (XOR bitów b4 i b9)
        feedback = xor(shift_register(4), shift_register(9));

        % Dodanie ostatniego bitu rejestru do sekwencji wyjściowej
        prbs_sequence(i) = shift_register(end);

        % Przesunięcie rejestru i wstawienie sprzężenia zwrotnego na początek
        shift_register = [feedback, shift_register(1:end-1)];
    end
end