% svd_color_image.m
clear all; close all; clc;

% Read the color image
img = imread('peppers.png'); % You can use any color image
img = double(img);
[m, n, c] = size(img);

% Initialize storage for singular values and errors
singular_values = cell(1, c);
errors = zeros(length(num_singular_values), c);

for ch = 1:c
    % Perform SVD for each color channel
    [U, S, V] = svd(img(:,:,ch));
    singular_values{ch} = diag(S);
    
    for i = 1:length(num_singular_values)
        k = num_singular_values(i);
        S_k = S;
        S_k(k+1:end, k+1:end) = 0; % Zero out smaller singular values
        img_reconstructed(:,:,ch) = U * S_k * V';
        
        % Calculate the reconstruction error
        errors(i, ch) = mean(mean((img(:,:,ch) - img_reconstructed(:,:,ch)).^2));
    end
end

% Combine the reconstructed channels
reconstructed_image = uint8(img_reconstructed);

% Display the reconstructed image
figure;
imshow(reconstructed_image);
title(['Reconstructed Color Image with ' num2str(k) ' Singular Values']);

% Plot singular values for each channel
figure;
for ch = 1:c
    subplot(1, 3, ch);
    plot(singular_values{ch}, 'bo-');
    title(['Singular Values for Channel ' num2str(ch)]);
    xlabel('Index');
    ylabel('Value');
end

% Plot the reconstruction error for each channel
figure;
for ch = 1:c
    plot(num_singular_values, errors(:,ch), 'o-');
    hold on;
end
title('Reconstruction Error vs. Number of Singular Values for Each Channel');
xlabel('Number of Singular Values');
ylabel('Mean Squared Error');
legend('Red Channel', 'Green Channel', 'Blue Channel');
grid on;
