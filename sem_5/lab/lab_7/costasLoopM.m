function [outData,err]=costasLoopM(inData,loopBW,AdaptBW)
%odbiornik Costasa (decision directed PLL) dla QPSK
	if nargin < 2
		loopBW=2*pi/100.0;
        AdaptBW=0;
    elseif nargin < 3
        AdaptBW=0;
    end

damp=0.5 * sqrt(2.0);
d_freq=0;
d_phase=0;
error=0;
alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);

	for ind=1:size(inData)

		outData(ind) = cos(d_phase) - 1i * sin(d_phase);
		outData(ind) = outData(ind) * inData(ind);
		error = phase_detector(outData(ind));

      if AdaptBW  
        loopBW = 0.93 * loopBW + 0.000515 * abs(error);    
            if loopBW<2*pi/1000
                loopBW=2*pi/1000;
            end
            if loopBW>2*pi/100
                loopBW=2*pi/100;
            end
        alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
        beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW); 
      end        
        
		d_freq = d_freq + beta * error;
		err(ind)=d_freq + alpha * error;
		d_phase = d_phase  + d_freq + alpha * error;   
		d_phase=phase_wrap(d_phase);
	end
    
end

function [phErr] = phase_detector(error)

 rErr=real(error);
 iErr=imag(error);
 
   if rErr < 0
     phErr=-iErr;
   else
     phErr=iErr;
   end
   
   if iErr < 0
     phErr = phErr + rErr;
   else
     phErr = phErr - rErr;
   end
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
