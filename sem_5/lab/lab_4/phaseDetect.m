function [phErr] =  phaseDetect(error)
 rErr=real(error);
 iErr=imag(error);
 
   if rErr < 0
     phErr=-iErr;
   else
     phErr=iErr;
   end
   
   if iErr < 0
     phErr = real(phErr + rErr);
   else
     phErr = real(phErr - rErr);
   end
end 