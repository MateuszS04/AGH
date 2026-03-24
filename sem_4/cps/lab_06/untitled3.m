clear all; close all; clc;

[x, fs] = audioread('s5.wav');
x = x(:,1); % tylko jedna ścieżka (mono)

frame_len = 2048;
frame_shift = 2300;
threshold = 0.3;
min_gap = 4000;
last_detected_index = -inf;

dtmf_freqs_low = [697, 770, 852, 941];
dtmf_freqs_high = [1209, 1336, 1477];

dtmf_keys = ['1','2','3';
             '4','5','6';
             '7','8','9';
             '*','0','#'];

digits = '';
index = 1;

while index + frame_len - 1 <= length(x)
    frame = x(index:index+frame_len-1);
    fft_frame = abs(fft(frame .* hamming(length(frame))));
    fft_frame = fft_frame(1:floor(end/2));
    freqs = (0:length(fft_frame)-1) * (fs/length(frame));
    freqs = freqs(1:floor(end/2));

    [~, peaks_idx] = sort(fft_frame, 'descend');
    peak_freqs = sort(freqs(peaks_idx(1:5)));

    low = peak_freqs(find(peak_freqs < 1000, 1, 'last'));
    high = peak_freqs(find(peak_freqs > 1000, 1, 'first'));

    if ~isempty(low) && ~isempty(high)
        [~, row] = min(abs(dtmf_freqs_low - low));
        [~, col] = min(abs(dtmf_freqs_high - high));
        detected_digit = dtmf_keys(row, col);

        if fft_frame(peaks_idx(1)) > threshold && ...
           (isempty(digits) || digits(end) ~= detected_digit) && ...
           (index - last_detected_index > min_gap)

            digits(end+1) = detected_digit;
            last_detected_index = index;
        end
    end

    index = index + frame_shift;
end

disp(['Zdekodowana sekwencja DTMF: ', digits]);
