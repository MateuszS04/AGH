clear all;
close all;

T = 2;
f = 50;
fs1=200;
dt = 1/fs1;
A=230;
%sygnał do odtworzenia
t1 = 0: dt: T;
y1=A*sin(2*pi*f*t1);

%częstotliwość próbkowania
fpr2 = 10000;
dt2 = 1/fpr2;

%sygnał zrekonstruowany
t2 = 0: dt2 :T;
y2 = zeros(length(t2), 1);

for i = 1:length(t2)
    y = 0;
    for j = 1:length(t1)
        b = pi / dt * ((i-1)*dt2 - (j-1)*dt);
        sb = 1;
        if b ~= 0
            sb = sin(b) / b;
        end
        y = y + y1(j) * sb;
    end
    y2(i) = y;
end
%błąd rekonstrukcji 
orginal=A*sin(2*pi*f*t2);
%reconstruction_error=mean((orginal(:)-y2(:)').^2);%obliczanie błędu rekonstrukcji przy pomocy średniego błędu kwadratowego
error_signal=orginal(:)-y2(:);
%error_signal=orginal(:)-interp1(t1,y2,t2,'linear','extrap');
reconstruction_error=mean(error_signal.^2);
hold on;
plot(t1, y1, 'r-o');
plot(t2, y2, 'g-x');
figure;
plot(t2,error_signal,'m')
disp(num2str(reconstruction_error))
