function [outData] = addScrambler(dataStream,mask,seed,regLen)
%UNTITLED2 Summary of this function goes here
%example usage B=addScrambler(A,0xff,0x171,9);
%   Detailed explanation goes here
outData=uint8(zeros(length(dataStream),1));
d_shift_register_length=regLen;
d_shift_register=mask;
polyn=seed;
	for i=1:length(dataStream)
        output=0;
        for b=1:8
		    output = bitshift(output,-1);
            if bitand(d_shift_register,1)
                output = bitor(output,0x80);
            end
%		newbit=length(find(int2bit(bitand(cast(d_shift_register,'uint64'),cast(polyn,'uint64')),d_shift_register_length)));%liczba jedynek w d_shift_register
		newbit=length(find(de2bi(bitand(cast(d_shift_register,'uint64'),cast(polyn,'uint64')),d_shift_register_length)));%liczba jedynek w d_shift_register  dla matlabów starszych niż 2021b
		newbit = bitand(newbit , 1);
        d_shift_register =bitor(cast(bitshift(d_shift_register,-1),'uint64'),cast(bitshift(newbit,d_shift_register_length),'uint64'));	
        end
    outData(i)=bitxor(dataStream(i,1), output,'uint8'); 
    end
end