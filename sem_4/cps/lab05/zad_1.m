p=[-0.5+9.5j,-0.5-9.5j,-1+10j,-1-10j,-0.5+10j,-0.5-10j];
z=[+5j,-5j,+15j,-15j];
p_real=real(p);
p_imag=imag(p);
z_real=real(z);
z_imag=imag(z);
figure; scatter(p_real,p_imag,'Marker','*','Displayname','p_imaginary'); 
hold on; 
scatter(z_real,z_imag,'Marker','o','Displayname','z_imaginary'); 
grid on; title('Zera (o) i Bieguny (*)'); 
xlabel('Real()'); 
ylabel('Imag()'); legend show; 

b=poly(z);
a=poly(p);

w=linspace(0,30,1000);%generujemy wektor częstotliwości od 0 do 30 rad/s i tysiąc punktów pomiędzy tymi wartościami
jw=1i*w;
H_1=polyval(b,jw)./polyval(a,jw);

K=1/max(abs(H_1));%dzięki temu fragmentowi maksymalne wzmocnienie jest rówene 1
b=b*K;
H_2=polyval(b,jw)./polyval(a,jw);

figure;
plot(w,abs(H_2));
xlabel('f [Hz]'); title('|H(f)|');
grid;
xlim([7.5 12.5]);

figure; 
plot(w,20*log10(abs(H_2))); 
xlabel('f [Hz]'); title('|H(f)| [dB]'); 
grid;
xlim([7.5 12.5]); 

figure;
plot(w,unwrap(angle(H_2)));
xlabel('f [Hz]'); title('odpowiedz fazowa');%oś pozioma w Hz, pionowa w radianach
grid;
xlim([4 18]);
H_db=20*log10(abs(H_2));
w_stop1=(w<7.5);
w_stop2=w>12.5;
min_stop1=min(H_db(w_stop1));
min_stop2=min(H_db(w_stop2));
fprintf('Minimalne tłumienie w niskim paśmie zaporowym: %.2f db\n',-min_stop1);
fprintf('Minimalne tłumienie w wysokim paśmie zaporowym: %.2f db\n',-min_stop2);

passband=(w>=8)&(w<=12);
gain_max=max(abs(H_2(passband)));
fprintf('Maksymalne wzmocnienie w paśmie przepustowym: %.3f\n',gain_max);



%Czy filtr jest pasmowoprzepustowy?
%Tak jest, ponieważ zera są ustawone w niskich częstotliwościach, okolice (5,-5)rad/s i wysokich (15,-15)rad/s,
%czyli filtr przepuszcza określone częstotliwości sygnału, a częstotliwości
%niższe lub wyższe od przepustowej tłumi
%a bieguny w okolicach (-10,+10)rad/s -> wzmacniają środek pasma.
%Tłumienie w paśmie zaporowym 
%Niskie pasmo 82.10, wysokie pasmo 87.70 To oznacza, że filtr dobrze tłumi sygnały poza pasmem przepustowym