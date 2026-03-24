clear all
close all
open('uniqueWordBatch');
set_param('uniqueWordBatch','AlgebraicLoopSolver','LineSearch');
%set_param('uniqueWordBatch','AlgebraicLoopSolver','TrustRegion');
BerU(1,1)=0;
BerD(1,1)=0;

maxNumErrs=50;
maxNumBits=1e8;

i=1;
	for EbNo=8:15
	sim('uniqueWordBatch');
	BerU(i,1)=BER(1,1);
	i=i+1;
    end

close_system('uniqueWordBatch');
open('diffQpskBatch');    
    
i=1;
	for EbNo=8:15
	sim('diffQpskBatch');
	BerD(i,1)=BER(1,1);
	i=i+1;
    end

close_system('diffQpskBatch');
EbNo=8:15;
semilogy(EbNo,BerU,'xr-');
hold on;
grid on;
semilogy(EbNo,BerD,'xg-');

set(gca, 'YMinorGrid', 'off');
yMin = 10.^(floor(log10(min(BerU))));
yMax = 10.^(ceil(log10(max(BerU))));
xMin = min(EbNo(:));
xMax = max(EbNo(:));
axis([xMin xMax yMin yMax]);

title('Porównanie metody Unique Word i modulacji ró¿nicowej');
xlabel('EbNo [dB]')
ylabel('BER');
legend('Metoda unique word','Metoda ró¿nicowa');
