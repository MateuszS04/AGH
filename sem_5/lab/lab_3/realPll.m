function [outData,err]=realPll(inData,loopBW,omega0)
%real signal PLL with frequency divider
%parameters loopBW - loop bandwidth
damp=0.5 * sqrt(2.0);
d_freq=0;
d_phase=0.1;
error=0;
alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);

for ind=2:size(inData)
    outData(ind,1) = cos(d_phase);
    error=phase_detector(d_phase,inData(ind,1));

    d_freq = d_freq + beta * error;
    err(ind,1)=d_freq;% + alpha * error;

    d_phase = d_phase  + d_freq + alpha * error + omega0;   
    d_phase=phase_wrap(d_phase);

end
    
end

function [phErr] = phase_detector(ph1,ph2)

phErr=-cos(ph1)*ph2;

end

function [pwr] =  phase_wrap(d_phase)

      while d_phase > (2.0 * pi)
	d_phase = d_phase - (2.0 * pi);
      end

      while d_phase < (-2.0 * pi)
	d_phase = d_phase + (2.0 * pi);
      end
pwr=d_phase;
end
