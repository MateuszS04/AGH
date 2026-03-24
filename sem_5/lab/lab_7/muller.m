function [outData,err]=muller(inData,varargin)
%przyjmujemy domyslną wartość sps wynoszącą 1
%parametry obowiązkowe: 
%inData - dane wejsciowe IQ
%parametry opcjonalne:
%loopBW - pasmo pętli watosc domyslna 2*pi/1000
%interpolation - metoda interpolacji dopuszczalne wartosci linear(domyślna) i Farrow
%przykładowe wywołanie:
%[wynik,err]=gardner(IQsamples,'loopBW', 2*pi/500,'interpolation','Farrow')

 validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
 p = inputParser;
 addRequired(p,'inData');
 addParameter(p,'interpolation','linear',@(x) any(validatestring(x,{'linear','Farrow'})));
 addOptional(p,'loopBW',2*pi/1000.0,validScalarPosNum); 
 parse(p,inData,varargin{:});
   
 intMode=p.Results.interpolation;
 loopBW=p.Results.loopBW;
 damp=0.5 * sqrt(2.0);

 d_freq=0;
 d_phase=0;
 error=0;
 alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
 beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
 j=1;


	if strcmp(intMode,'Farrow')
		%farrow filter for quadratic interpolation
		%init Farrow structure for the signal
		kwF=filter([0.5 -1 0.5],1,inData);
		linF=filter([-1.5 2 -0.5],1,inData);
		consF=filter([1 0 0],1,inData);
	end
 
 intS=0;
 intSp1=0;

 
	for ind=2:size(inData)-2
		if strcmp(intMode,'Farrow')
			%farrow quadratic interpolator
			intSp1=kwF(ind)*d_phase*d_phase + linF(ind)*d_phase + consF(ind);
			intS=kwF(ind-1)*d_phase*d_phase + linF(ind-1)*d_phase + consF(ind-1);
		else
			%linear interpolator
			intSp1=inData(ind+1)*(1-d_phase)+inData(ind)*d_phase;
			intS=inData(ind)*(1-d_phase)+inData(ind-1)*d_phase;
		end
		outData(j,1) = intS;
		error=-timing_err(intS,intSp1);
		d_freq = d_freq + beta * error;
	%    err(j,1)=d_freq + alpha * error;
		d_phase = d_phase  + d_freq + alpha * error;   
		err(j,1)=d_phase;
		d_phase=phase_wrap(d_phase);
		j=j+1;
	end
    
end



function [tErr] = timing_err(xkm1,xk)
%tErr=real((xk*sign(xkm1)-xkm1*sign(xk)));
tErr=real(xk)*sign(real(xkm1))-real(xkm1)*sign(real(xk)) + ...
     imag(xk)*sign(imag(xkm1))-imag(xkm1)*sign(imag(xk));
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
