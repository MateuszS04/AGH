clc; clear;

x5 = load('lab11.txt')';  


%% 2. Prawdopodobieństwo symbloi
[symTable, ~, ~] = unique(x5);        % unikalne symbole
counts = histc(x5, symTable);         % liczność
prob = counts / sum(counts);  %prawdopodobieństwo

%% 3. Sortowanie prawdopodobieństw
[probSorted, sortIdx] = sort(prob, 'ascend'); % sortujemy rosnąco według pradopodobieństwa rosnąco 
symbolsSorted = symTable(sortIdx);

%% 4. Budowa drzewa Huffmana
% łączymy dwa symbole o najmniejszy prawdopodobieństwe wystąpienia 
n = length(probSorted);
nodes = num2cell(symbolsSorted);
probs = num2cell(probSorted);

while length(probs) > 1 %dopóki są więcej niż dwa symbole łączymy dwa o najmniejszym pradopodobieństwie 
    % Pobierz dwa najmniejsze elementy
    [p1, p2] = deal(probs{1}, probs{2});
    [n1, n2] = deal(nodes{1}, nodes{2});
    
    % Połącz węzły
    newNode = {n1, n2};
    newProb = p1 + p2;
    
    % Usuń i dodaj z powrotem
    probs = probs(3:end);
    nodes = nodes(3:end);
    
    % Wstaw w odpowiednie miejsce (utrzymaj sortowanie)
    insertIdx = find(cell2mat(probs) > newProb, 1);
    if isempty(insertIdx)
        probs{end+1} = newProb;
        nodes{end+1} = newNode;
    else
        probs = [probs(1:insertIdx-1), {newProb}, probs(insertIdx:end)];
        nodes = [nodes(1:insertIdx-1), {newNode}, nodes(insertIdx:end)];
    end
end

tree = nodes{1};  % Korzeń drzewa

%% 5. Generowanie tablicy kodowej
codebook = containers.Map('KeyType', 'double', 'ValueType', 'char');
buildCodebook(tree, '', codebook);  % każdemu symbolowi przypisujemy odpowiednią liczbę bitów

disp('Tablica kodowa:');
disp(codebook);

%% 6. Kodowanie sekwencji x5
encoded = '';
for i = 1:length(x5)
    encoded = [encoded, codebook(x5(i))]; % kodowanie sekwencji
end
fprintf('Zakodowana sekwencja (%d bitów):\n', length(encoded));
disp(encoded);

%% 7. Wprowadzenie błędu – losowa zmiana jednego bitu
bitToFlip = randi(length(encoded));
encodedErr = encoded;
encodedErr(bitToFlip) = char('1' + '0' - encoded(bitToFlip));  % Zamień 0 <-> 1
fprintf('Zmieniono bit nr %d (błąd w transmisji)\n', bitToFlip);

%% 8. Dekodowanie oryginalnej i błędnej sekwencji
decodebook = containers.Map(values(codebook), keys(codebook));  % Odwrócona mapa

decodedOriginal = huffmanDecode(encoded, decodebook);
decodedWithError = huffmanDecode(encodedErr, decodebook);



%% 9. Porównanie i analiza błędów
nErrors = sum(decodedOriginal ~= decodedWithError);
fprintf('Liczba błędnych symboli po 1-bitowym błędzie: %d z %d (%.1f%%)\n', ...
    nErrors, length(x5), 100 * nErrors / length(x5));


%% Funkcja: Rekurencyjne tworzenie kodów
function buildCodebook(tree, prefix, map)
    if ~iscell(tree)
        map(tree) = prefix;
    else
        buildCodebook(tree{1}, [prefix '0'], map);
        buildCodebook(tree{2}, [prefix '1'], map);
    end
end

%% Funkcja: Dekodowanie ciągu bitów
function decoded = huffmanDecode(bitstream, decodebook)
    decoded = [];
    i = 1;
    while i <= length(bitstream)
        matched = false;
        for k = 1:10  
            if i + k - 1 <= length(bitstream)
                key = bitstream(i:i+k-1);
                if isKey(decodebook, key)
                    decoded(end+1) = decodebook(key); %#ok<AGROW>
                    i = i + k;
                    matched = true;
                    break;
                end
            end
        end
        if ~matched
            warning('Nie udało się zdekodować od pozycji %d', i);
            break;
        end
    end
end
% przy dekodowaniu posługujemy się odwróconą książką kodową gdzie ciągi
% bitów to klucze a wartościami są symbole 