rx = sdrrx('Pluto','BasebandSampleRate',1e6, 'CenterFrequency',868e6,'OutputDataType','double');
capture(rx,5,'Seconds','Filename','testQpskOnly.bb');