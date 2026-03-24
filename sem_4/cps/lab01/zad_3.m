L = load('adsl_x.mat');
x = L.x;


M = 32;    
N = 512;   
K = 4;     

prefix_pattern = x(N-M+1:N);

[corr_vals, lags] = xcorr(x, prefix_pattern);

[~, peak_idx] = findpeaks(corr_vals, 'MinPeakHeight', max(corr_vals) * 0.47);

start_indices = lags(peak_idx(lags(peak_idx) >= 0)) + 1;

disp('numery prefiksów');
disp(start_indices);
figure;
plot(x);
hold on;

% Zaznaczenie miejsc prefiksów
for i = 1:length(start_indices)
    xline(start_indices(i), 'r-', ['Prefiks ' num2str(i)]);
end
xlabel('Numer próbki');
ylabel('Amplituda');
grid on;

