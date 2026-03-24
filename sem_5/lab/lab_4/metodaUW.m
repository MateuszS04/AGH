clear all
close all
clc
%jedn¹ z metod przeciwdzia³ania niejednoznacznoœci dekodowania fazy przez
%odbiornik Costasa jest do³¹czenie do strumienia danych sekwencji symboli
%znanych stronie odbiorczej. Sekwencje te nie s¹ przypadkowe. Z regu³y
%stosowane s¹ tzw. kody ortogonalne o specjalnych w³asnoœciach funkcji
%korelacji. Jednym z przyk³adów unikalnych sekwencji s¹ kody Golda.
%Odkomentuj nastepn¹ liniê aby dowiedzieæ siê wiêcej o ich generowaniu
%doc('Gold Sequence Generator');

%Przetestujmy pewn¹ ciekaw¹ w³asnoœæ kodów Golda

%generujemy 32 bitow¹ sekwencjê znan¹ równie¿ po stronie odbiorczej 
hgld = comm.GoldSequence('FirstPolynomial',[5 2 0],'SecondPolynomial', [5 4 3 2 0],'FirstInitialConditions', 1,'SecondInitialConditions', 1,'Index', 4, 'SamplesPerFrame', 32);
headBits= step(hgld);
%umieszczamy sekwencjê w strumieniu danych
dataStream = [randi([0 1],100,1); headBits; randi([0 1],100,1)];

qpskmod = comm.QPSKModulator('BitInput',true); %konstruujemy obiekt modulatora
modSig = qpskmod.step(dataStream);%modulujemy

%zajmijmy siê teraz stron¹ odbiornika
%konstruujemy detektor sekwencji kodowej Golda korzystaj¹c z w³asnoœci jego
%funkcji autokorelacji

recSig = qpskmod.step(headBits);%modulujemy
recSig=conj(recSig);
preambleUP=flipud(recSig);

%filtrujemy sygna³ w odbiorniku
y=filter(preambleUP,1,modSig);
%sprawdŸmy w którym miejscu amplituda sygna³u na wyjœciu filtru osi¹ga
%maksimum
plot(abs(y));
%zobaczmy dla której próbki wystêpuje maksimum
[~, ind] =max(abs(y));
%zobaczmy jeszcze na fazê naszego maksimum
fprintf('maksimum przypada na %d próbkê i ma fazê %g stopni\n',ind, (180/pi)*angle(y(ind)));
%teraz zasymulujmy jedn¹ z niejednoznacznoœci fazy, czyli na przyk³ad obrót
%konstelacji o pi/2
skewSig=modSig*exp(1i*pi/2);
%przepuœæmy pomownie sygna³ przez filtr odbiornika

y=filter(preambleUP,1,skewSig);
%sprawdŸmy w którym miejscu amplituda sygna³u na wyjœciu filtru osi¹ga
%maksimum
plot(abs(y));
%zobaczmy dla której próbki wystêpuje maksimum
[~, ind] =max(abs(y));
%zobaczmy jeszcze na fazê naszego maksimum
fprintf('maksimum przypada na %d próbkê i ma fazê %g stopni\n',ind, (180/pi)*angle(y(ind)));
%W tym momencie odpowiednie skorygowanie odebranej sekwencji nie nastrêcza
%problemów
