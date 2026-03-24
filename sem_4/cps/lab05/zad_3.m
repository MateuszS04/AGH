clear all;
close all;

sampling_freq=256*1000;
cutoff= sampling_freq/2;
points=4096;
w=linspace(0,sampling_freq,points)*2*pi;
% butterworth filter
[zb,pb,kb]=butter(7,2*pi*1000*64,'s');
%7-rząd filtru, 2*pi*g4*1000- częstotliwość odcięcia bo filtr analogowy
%'s'-oznaczenie filtru analogowego
%zb-zera filtru(dla tego typu puste
%pb- bieguny filtru
%kb-wzmocnienie filtru
[bb,ab]=zp2tf(zb,pb,kb);%konwersca reprezentacji filtra z postaci zer i biegunów na postaci przenoszenia
hb=freqs(bb,ab,w);%wyliczenie odpowiedzi częstotliwościowej

[z1,p1,k1]=cheby1(5,3,2*pi*1000*64,'s');
%3-maksymalne zafalowanie w paśmie przenoszenia (dopuszczalne odbicie w dB)
%reszta tak samo jak w poprzednim filtrze
[b1,a1]=zp2tf(z1,p1,k1);
h1=freqs(b1,a1,w);

%40 to tłumienie w paśmie tłumienia
[z2,p2,k2]=cheby2(5,40,2*pi*1000*112,'s');
[b2,a2]=zp2tf(z2,p2,k2);
h2=freqs(b2,a2,w);

[ze,pe,ke]=ellip(3,3,40,2*pi*1000*64,'s');
[be,ae]=zp2tf(ze,pe,ke);
he=freqs(be,ae,w);

if min(mag2db(abs(hb(1:points/4))))<-3%swprawdzamy czy najgorszy przypadek tłumenia w filtrze nie spada ponożej 3dB
    "Filtr Butter ma zbyt duże zmiany tłumienia dla f<f_s/4"
end
if min(mag2db(abs(h1(1:points/4))))<-3
    "Filtr Czeby1 ma zbyt duże zmiany tłumienia dla f<f_s/4"
end
if min(mag2db(abs(h2(1:points/4))))<-3
    "Filtr Czeby2 ma zbyt duże zmiany tłumienia dla f<f_s/4"
end
if min(mag2db(abs(he(1:points/4))))<-3
    "Filtr Elipt ma zbyt duże zmiany tłumienia dla f<f_s/4"
end
if mag2db(abs(hb(points/2)))>-40
    "Filtr Butter nie tłumi wystarczająco dla f=f_s/2"
end
if mag2db(abs(h1(points/2)))>-40
    "Filtr Czeby1 nie tłumi wystarczająco dla f=f_s/2"
end
if mag2db(abs(h2(points/2)))>-40
    "Filtr Czeby2 nie tłumi wystarczająco dla f=f_s/2"
end
if mag2db(abs(he(points/2)))>-40
    "Filtr Elipt nie tłumi wystarczająco dla f=f_s/2"
end


plot([w;w;w;w]'/(2e3*pi),mag2db(abs([hb;h1;h2;he]')));
axis([0 256 -45 5])
grid;
title("Odpowiedź częstotliwościowa modelów")
xlabel("Częstotliwość (kHz)");
ylabel("Odpowiedź (dB)");
rectangle('Position',[0 -45 64 42],'FaceColor','green','LineWidth',0.1,'EdgeColor','k','Visible',true)
line([128 128],[5 -40],'LineWidth',0.1,'Visible',true,'Color','k');

legend(["Butter" "Czeby1" "Czeby2" "Elipt"]);

figure;
polarscatter(angle(z2),abs(z2),'o');
hold on;
polarscatter(angle(ze),abs(ze),'x');
polarscatter(angle(pb),abs(pb),'*');
polarscatter(angle(p1),abs(p1),'+');
polarscatter(angle(p2),abs(p2),'square');
polarscatter(angle(pe),abs(pe),'diamond');
hold off;
title("Położenia zer i biegunów filtrów");
legend(["Czeby2 - zera" "Elipt - zera" "Butter - bieg" "Czeby1 - bieg" "Czeby2 - bieg" "Elipt - bieg"]);