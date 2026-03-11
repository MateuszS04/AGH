
N = 1000;
k_values = 1:10;

% sygnał sinusoidalny
x = sin(2 * pi / N * (0:N-1));


dx_true = cos(2 * pi / N * (0:N-1));    % pierwsza pochodna
d2x_true = -sin(2 * pi / N * (0:N-1));  % druga pochodna 

% szum gaussowski
x_noisy = x + 0.1 * randn(1, N);

%tablice do przechowywania błędów
mean_error_d1 = zeros(1, length(k_values));
mean_error_d2 = zeros(1, length(k_values));


for idx = 1:length(k_values)
    k = k_values(idx);
    
    %pierwsza pochodna numeryczna
    d1_num = (x_noisy(1+k:N) - x_noisy(1:N-k)) / k;
    
    % druga pochodna numeryczna
    d2_num = (x_noisy(1+2*k:N) - 2 * x_noisy(1+k:N-k) + x_noisy(1:N-2*k)) / (k^2);
    
    % obliczony błąd dla pierwszej pochodnej 
    error_d1 = abs(dx_true(1+k:N) - d1_num);
    mean_error_d1(idx) = mean(error_d1);
    
    % obliczony błąd dla drugiej pchodnej z pominięciem boundary effect 
    error_d2 = abs(d2x_true(1+2*k:N) - d2_num);
    mean_error_d2(idx) = mean(error_d2);
end

% znaleźenie optymalnego k dla pierwszej pochodnej z najmniejszym błędem
[~, optimal_k_idx] = min(mean_error_d1);
optimal_k = k_values(optimal_k_idx);

[~, optimal_k_idx_d2] = min(mean_error_d2);
optimal_k_d2 = k_values(optimal_k_idx_d2);
fprintf('optymalne k dla drugiej pochodnej %d\n', optimal_k_d2);

% Display results
fprintf('optymalne k dla pierwszej pochodnej %d\n', optimal_k);

% średni błąd 
figure;
subplot(2,1,1);
plot(k_values, mean_error_d1, '-o');
title('średni błąd dla pierwszej pochodnej w zależności od k');
xlabel('k');
ylabel('średni błąd dla pierwszej pochodnej');

subplot(2,1,2);
plot(k_values, mean_error_d2, '-o');
title('średni błąd dla drugiej pochodnej w zależności od k');
xlabel('k');
ylabel('średni błąd dla drugiej pochodnej');
