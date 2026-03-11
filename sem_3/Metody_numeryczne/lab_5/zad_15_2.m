function B_spline()
    x_j = 0;   
    
    x_values = linspace(-3, 3, 500);%generujemy 500 punktów ustawionych od -3 do 3
    y_values = arrayfun(@(x) Bj3(x, x_j), x_values);%wbudowana funkcja, wykorzystywana do wykonania operacji na każdym elemencie macierzy
    
   %wykres
    figure;
    plot(x_values, y_values, "b", "LineWidth", 1.5);
    xlabel("x");
    ylabel("Bj(x)");
end

function y = Bj3(x, x_j)
    u = x - x_j;
    
   
    if (1 <= u) && (u < 2)%obliczanie wartości funkcji dla pszczególnych przedziałów
        y = (1 - u)^3 / 6;
    elseif (0 <= u) && (u < 1)
        y = (3 * u^3 - 6 * u^2 + 4) / 6;
    elseif (-1 <= u) && (u < 0)
        y = (-3 * u^3 + 3 * u^2 + 3 * u + 1) / 6;
    elseif (-2 <= u) && (u < -1)
        y = u^3 / 6;
    else
        y = 0; %poza obszarem naszej funkcji
    end
end
