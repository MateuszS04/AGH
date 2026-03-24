function [syms]=tetraMod(bits)
%funkcja przyjmuje wektor bitów w formacie zgodnym z pokazanym poniżej wektorem bits
%bits = [0 0 0 1 1 0 1 1 0 0 1 ];
%zwracany jest wektor zmodulowanych symboli
accu=1;
syms=ones(ceil(length(bits)/2)+1,1);
    if bitand(length(bits),1)
	bits=[bits 0];
    end
duoBit=reshape(bits,2,[])';
nums=bi2de(duoBit, 'left-msb');

    for i=1:length(nums)
        switch nums(i)
    case 0
        accu=accu*exp(1j*pi/4);
    case 1
        accu=accu*exp(1j*3*pi/4);
    case 2
        accu=accu*exp(-1j*pi/4);
    case 3
        accu=accu*exp(-1j*3*pi/4);
        end
    syms(i+1)=accu;    
    end

end