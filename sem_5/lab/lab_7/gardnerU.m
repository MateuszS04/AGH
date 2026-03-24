function [outData,err]=gardnerU(inData,sps,loopBW)
	if nargin < 3
		loopBW=0.5*pi/100.0;
    end
	if mod(sps,2)
	disp('sps parameter must be an even integer');
	exit;
	end

d_freq=0;
d_phase=0;
error=0;
damp=0.5 * sqrt(2.0);
alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
j=1;
k=0;% <--timing offset between transmitter and receiver
for ind=1:sps:size(inData)-2*sps
    outData(j,1) = inData(ind+k);
    error=timing_err(inData(ind + k),inData(ind + sps/2 +k),inData(ind + sps + k));
    d_freq = d_freq + beta * error;
    err(j,1)=k;%d_freq + alpha * error;
    d_phase = d_phase  + d_freq + alpha * error;   
    d_phase=phase_wrap(d_phase);
	k=floor(d_phase*sps);
	j=j+1;
end
    
end



function [tErr] = timing_err(xkm1,xk,xkp1)
tErr=(real(xkm1)-real(xkp1))*real(xk)+(imag(xkm1)-imag(xkp1))*imag(xk);
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
