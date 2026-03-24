function x_out = dekodtr(sym, N, Q)
    H = N/2;
    M = size(sym, 2);
    win = sin(pi*((0:(N-1)) + 0.5)/N)';
    x_out = zeros(H*(M+1), 1);

    for m = 0:M-1
        Fkq = sym(:, m+1) ./ Q; % odwrotne skalowanie
        x0 = idct4(Fkq);        % odwrotna transformacja
        x0 = x0 .* win;         % odwrotne okienkowanie

        n0 = m*H + 1;
        x_out(n0:n0+N-1) = x_out(n0:n0+N-1) + x0; % nakładanie
    end
end
