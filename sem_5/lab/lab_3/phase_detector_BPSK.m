function [pherr] = phase_detector_BPSK(error)
rErr=real(error);
iErr=imag(error);
pherr=rErr*iErr;
end

%modulacja BPSk wykorzystuje tylko dwa stany fazy 0 i 180 więc symbole leżą
%tylko na osi rzeczywistej 
% detektor generuje sygnał błędu który jest proporcjonalny do błędu fazy
%