x1 = [0, 1, 2, 3, 3, 2, 1, 0];
x2 = [0, 7, 0, 2, 0, 2, 0, 7, 4, 2];
x3 = [0, 0, 0, 0, 0, 0, 0, 15];

H1 = shannon_entropy(x1);
H2 = shannon_entropy(x2);
H3 = shannon_entropy(x3);

fprintf('Entropia x1: %.4f bity\n', H1);
fprintf('Entropia x2: %.4f bity\n', H2);
fprintf('Entropia x3: %.4f bity\n', H3);


function H = shannon_entropy(x)    
    [unique_symbols, ~, idx] = unique(x);%znajduje unikalne wartości w ciagu
    counts = histcounts(idx, 1:(length(unique_symbols)+1));%liczymy ile razy nasz unikalny symbol występuje w ciągu 
    
    p = counts / sum(counts);% obliczmay prawdopodobieńśtwo wystąpienia symbolu
    
    H = -sum(p(p > 0) .* log2(p(p > 0))); % filtrujemy elementyz zerowym pradopodobieńśtwem wystąpienia
    %i obliczmy Entropię z wzoru Shanona 
end
