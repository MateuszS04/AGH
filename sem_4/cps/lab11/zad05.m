clc; clear;

rng(0);
x4 = randi([1 5], 1, 10);  
disp('Sekwencja x4:');
disp(x4);


% Przypisane ręcznie na podstawie drzewa Huffmana
symbols = [1, 2, 3, 4, 5];
codebook = containers.Map( ...
    {1, 2, 3, 4, 5}, ...
    {'00', '01', '100', '1010', '1011'} ...
);


encoded = '';
for i = 1:length(x4)
    encoded = [encoded, codebook(x4(i))];
end
disp('Zakodowana sekwencja bitów:');
disp(encoded);


decodebook = containers.Map( ...
    {'00', '01', '100', '1010', '1011'}, ...
    {1, 2, 3, 4, 5} ...
);


decoded = [];
i = 1;
while i <= length(encoded)
    matched = false;
    for k = 1:4  % Sprawdzamy kod o długości od 1 do 4 bitów
        if i + k - 1 <= length(encoded)
            key = encoded(i:i+k-1);
            if isKey(decodebook, key)
                decoded(end+1) = decodebook(key);
                i = i + k;
                matched = true;
                break;
            end
        end
    end
    if ~matched
        error('Błąd dekodowania przy pozycji %d', i);
    end
end
disp('Odkodowana sekwencja:');
disp(decoded);


total_bits = length(encoded);
fprintf('liczb bitów %d\n', total_bits);


p = [0.35, 0.25, 0.2, 0.1, 0.1];
H = -sum(p .* log2(p));
fprintf('entropia %.4f bity/symbol\n', H);
fprintf('minimalna długość %.4f bitów\n', H * length(x4));
