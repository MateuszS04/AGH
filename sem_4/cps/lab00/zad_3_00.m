clear all; close all;
x = [zeros(1,9) ones(1,6) zeros(1,9)];
h= x;
y=splot(x,h);
yc=conv(x,h);
yf=filter(x,1,h);
plot(y);
hold on;
plot(yc);
plot(yf)
plot(x);
plot(h);

function out=splot(a,b)
out=zeros(1,length(a)+length(b));
for i =1:length(out)
    %buf=reverse(b)
    for j =-length(a):length(a)
        if(j+i-length(b)<length(b)&&j+i-length(b)>0&&j>0)
            buff=out(1,i);
            out(1,i)=buff+a(1,j)*b(1,j+i-length(b));
        end
    end
end

end
%nie całe
