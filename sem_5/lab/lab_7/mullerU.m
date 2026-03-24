function [outData,err]=mullerU(inData,sps)
%TODO: pasmo petli i wspolczynnik tlumienia powinny byc parametrami funkcji no i powinny miec wartosci domyslne
bw=0.5*pi/100.0;
damp=0.5 * sqrt(2.0);

d_freq=0;
d_phase=0;
error=0;
alpha = (4.0 * damp * bw) / (1.0 + 2.0 * damp * bw + bw * bw);
beta = (4.0 * bw * bw) / (1.0 + 2.0 * damp * bw + bw * bw);
j=1;
k=0;
for ind=1:sps:size(inData)-2*sps
    outData(j,1) = inData(ind+k);
    error=timing_err(inData(ind+k),inData(ind+sps+k));
    d_freq = d_freq + beta * error;
    err(j,1)=k;%d_freq + alpha * error;
    d_phase = d_phase  + d_freq + alpha * error;   
    d_phase=phase_wrap(d_phase);
	k=floor(d_phase*sps);
	j=j+1;
end
    
end



function [tErr] = timing_err(xkm1,xk)
%tErr=real((xk*sign(xkm1)-xkm1*sign(xk)));

tErr= real(xk)*sign(real(xkm1))-real(xkm1)*sign(real(xk))+ imag(xk)*sign(imag(xkm1))-imag(xkm1)*sign(imag(xk));
end





function [pwr] =  phase_wrap(d_phase)

      while d_phase > (1)
	d_phase = d_phase - (1);
      end

      while d_phase < (-1)
	d_phase = d_phase + (1);
      end
pwr=d_phase;
end
