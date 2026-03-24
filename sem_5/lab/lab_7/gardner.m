function [outData,err]=gardner(inData,varargin)
%przyjmujemy domysln¹ wartoœæ sps wynosz¹c¹ 2
%parametry obowi¹zkowe: 
%inData - dane wejsciowe IQ
%parametry opcjonalne:
%loopBW - pasmo pêtli watosc domyslna 2*pi/1000
%interpolation - metoda interpolacji dopuszczalne wartosci linear(domyœlna) i Farrow
%przyk³adowe wywo³anie:
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
 sps=2;
 d_freq=0;
 d_phase=0;
 error=0;
 alpha = (4.0 * damp * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
 beta = (4.0 * loopBW * loopBW) / (1.0 + 2.0 * damp * loopBW + loopBW * loopBW);
 j=1;
 %k=0;

	if strcmp(intMode,'Farrow')
		%farrow filter for quadratic interpolation
		kwF=filter([0.5 -1 0.5],1,inData);
		linF=filter([-1 2 -1.5],1,inData);
		consF=filter([0 0 1],1,inData);
	end

	for ind=3:sps:size(inData)-2

		if strcmp(intMode,'linear')
		%linear interpolation
			mm1=inData(ind-1)*(1-d_phase)+inData(ind-2)*d_phase;
			m0=inData(ind)*(1-d_phase)+inData(ind-1)*d_phase;
			m1=inData(ind+1)*(1-d_phase)+inData(ind)*d_phase;
		else
		%quadratic interpolation    
			mm1=kwF(ind-2)*d_phase*d_phase + linF(ind-2)*d_phase + consF(ind-2);
			m0=kwF(ind-1)*d_phase*d_phase + linF(ind-1)*d_phase + consF(ind-1);
			m1=kwF(ind)*d_phase*d_phase + linF(ind)*d_phase + consF(ind);
		end

	error=timing_err(mm1,m0,m1);
	d_freq = d_freq + beta * error;
%    err(j,1)=d_freq + alpha * error;
	d_phase = d_phase  + d_freq + alpha * error;   
        if strcmp(intMode,'Farrow')
            outData(j,1) = m0;
        else
            outData(j,1) = m1;
        end
	d_phase=phase_wrap(d_phase);
	err(j,1)=d_phase;%zamiast b³edu zwracamy estymatê opóŸnienia
	j=j+1;
	end
    
end



function [tErr] = timing_err(xkm1,xk,xkp1)
%funkcja do uzupe³nienia w nastepnym kroku jak zadziala
tErr=(real(xkp1)-real(xkm1))*real(xk)+(imag(xkp1)-imag(xkm1))*imag(xk);
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
