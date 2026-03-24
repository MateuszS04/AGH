function outPack=streamDecode(A)
%uwaga wektor ma byc kolumnowy!!!!! 20.10.2023
%funkcja przeznaczona do dekodowania strumienia odebranych bitow
%parametry wejsciowe:
%A-strumien bitow (0 1)
%outPack - dane wyjsciowe z postaci wektora znakow (char)

outPack=[];

B=2*A-1;
w=filter([-1 -1 1 1 1 1 1 1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 1 -1 1 -1 -1 -1 1 1 1 -1 -1 1 -1 -1 1 -1 1 1 -1 1 1 1 -1 1 1 -1 -1 1 1 -1 1 -1 1],1,B);

pkt=find(w>=63);%znajdz wszystkie naglowki pakietow
	for m=1:length(pkt)
        h=A(pkt(m)+1:pkt(m)+16);    
		pktSize=bi2de(h','left-msb');
            if pkt(m)+32+(pktSize-4)*8 >length(A)
                    if mod(length(A)-pkt(m)+33,8)==0
                      A=[A ; 0];  
                    end
                pldBin=reshape(A(pkt(m)+33:end-mod(length(A)-pkt(m)+33,8)+1),8,[]);
            else
                pldBin=reshape(A(pkt(m)+33:pkt(m)+32+(pktSize-4)*8),8,[]);
            end
        pldOut=uint8(bi2de(pldBin','left-msb'));
        pldOut=addScrambler(pldOut,0xff,0x171,9);
        
        outPack= [outPack; char(pldOut)];
    end
end