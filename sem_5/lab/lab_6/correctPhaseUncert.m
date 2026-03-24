function constel_corrected = correctPhaseUncert(constel,headF)
constel=constel(:);
headF=headF(:);


search_window=500;

if length(constel)<search_window
    search_window=length(constel);
end

% [c,lags]=xcorr(constel(1:search_window),headF);
[c,~]=xcorr(constel(1:search_window),headF);

[~,max_idx]=max(abs(c));
% best_lag=lags(max_idx);

peak_value=c(max_idx);
phase_offset_rad=angle(peak_value);

k_float=phase_offset_rad/(pi/2);
k_int=round(k_float);
final_correction=k_int*(pi/2);

rotator=exp(-1i*final_correction);
constel_corrected=constel*rotator;
% constel_corrected=constel_corrected(:);
fprintf('Korekcja fazy: wykryto obrót o %d stopni\n', round(rad2deg(final_correction)));
end