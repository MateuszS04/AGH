%zadaniem testu jest pokazanie jak dzia³a interpolator w strukturze Farrowa
%spróbujemy dokonaæ interpolacji przebiegu w ró¿nych przedzia³ach miêdzy
%próbkami bez koniecznoœci budowy dedykowanych filtrów interpolacyjnych i
%poddawania sygna³u procesowi filtracji.

%najpierw sygna³ który dobrze znamy który pos³u¿y nam za t³o i pozwoli
%zweryfikowaæ czy interpolator dzia³a poprawnie
x=[0:0.01*pi:2*pi];
y=sin(x);
plot(x,y);
hold on;
%teraz zdecymowana wersja sygna³u wzorcowego - ten sygna³ bêdziemy póŸniej
%interpolowaæ
x2=[0:0.1*pi:2*pi];
y2=sin(x2);
plot(x2,y2,'ro');
%maj¹c referencjê budujemy w³aœciwy filtr interpolacyjny w strukturze
%Farrowa do interpolacji kwadratowej. Sk³ada siê on z trzech komponentów
% kwF=filter([0.5 -0.5 -0.5 0.5],1,y2);
% linF=filter([-0.5 -0.5 1.5 -0.5],1,y2);
% consF=filter([0 1 0 0],1,y2);

kwF=filter([0.5 -1 0.5],1,y2);
linF=filter([-1.5 2 -0.5],1,y2);
consF=filter([1 0 0],1,y2);
%maj¹c "przygotowane" kompomnent mo¿emy dokonaæ interpolacji w dowolnie
%wybranym punkcie miêdzy próbkami sygna³u y2

z3=0.5*0.5*kwF+0.5*linF+consF; %<-- to ju¿ w³aœciwa interpolacja jak widaæ tutaj dok³adnie
%po³owie miêzy istniej¹cymi próbkami
%a teraz wyœwietalmy wynik
x3=[-0.05*pi:0.1*pi:(2-.05)*pi];
plot(x3,z3,'go');

%interpolacja w 1/4 odleg³oœci miêdzy próbkami... proszê bardzo
z4=0.25*0.25*kwF+0.25*linF+consF;
x4=[-0.025*pi:0.1*pi:(2.-.025)*pi];
plot(x4,z4,'ko');
grid on