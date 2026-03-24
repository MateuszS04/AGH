function dq = lab11_kwant(d, L)
    % Kwantyzacja typu mid-riser z ograniczeniem outlierów (clipping)
    perc = 99.2; % użyj 99% energii sygnału
    lim = prctile(abs(d), perc); % np. 99-ty percentyl amplitudy, czyli sygnał zostaje przycięty do 99,2 percentyla
    
    xmax = lim; % ogranicz zasięg, maksymalna wartość amplitudy
    delta = 2 * xmax / L; % krok kwantyzacji
    
    indices = floor((d + xmax) / delta);
    indices = max(0, min(indices, L-1));
    
    dq = -xmax + delta/2 + indices * delta; %obliczamy kwantyzowaną wartość dq
end

%% Dlatego że ograniczamy do 99,2 percentyla to ścian nam te wysokie amplitudy z sygnału, klaśnięcia w tym przypadku