function [outData,err]=bbpll(inData,loopBW,freqDiv)
%baseband PLL with frequency divider
%parameters loopBW - loop bandwidth
%freqDiv - frequency division factor
damp=0.5 * sqrt(2.0);
d_freq=0;
d_phase=0;
error=0;
alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);

for ind=1:size(inData)

    outData(ind,1) = cos(d_phase) - 1i * sin(d_phase);
    error=phase_detector(exp(-1i*freqDiv*d_phase),inData(ind,1));

%     loopBW = 0.995 * loopBW + 0.001 * abs(error);%0.9970,0.0015     
%         if loopBW<2*pi/1000
%             loopBW<2*pi/1000;
%         end
%         if loopBW>2*pi/100
%             loopBW=2*pi/100;
%         end
%     alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
%     beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);

    d_freq = d_freq + beta * error;
%   err(ind,1)=1.0/(loopBW/(2*pi));
    err(ind,1)=d_freq;% + alpha * error;

    d_phase = d_phase  + d_freq + alpha * error;   
    d_phase=phase_wrap(d_phase);
end
    
end

function [phErr] = phase_detector(ph1,ph2)

phErr=imag(ph1*ph2);

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
