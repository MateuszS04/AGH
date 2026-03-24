function bbtoWav(bbFileName)
tmp=strsplit(bbFileName,'.');
bbFileName=tmp(1);
fName=strcat(bbFileName,'.bb');
bbr = comm.BasebandFileReader(char(fName));
bbr.SamplesPerFrame=1e6;
iq=bbr();
y(:,1)=real(iq);
y(:,2)=imag(iq);
fs=bbr.SampleRate;
bbr.release();
fName=strcat(bbFileName,'.wav');
audiowrite(strcat(char(fName)),y,fs);
end