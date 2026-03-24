function [y,h,e] = lms_adaptive_identification(x,d,M,mu,gamma,choose)
    N=length(x);
    h=zeros(M,1);
    e=zeros(1,N);
    x_buff=zeros(M,1);
    y=zeros(1,N);
    for n=1:N
        x_buff=[x(n);x_buff(1:end-1)];%dodajemy nową próbkę na początek
        y(n)=h'*x_buff;%obliczanie wyjścia filtru
        e(n)=d(n)-y(n);%obliczanie błędu
        if(choose==1)%standardowy LMS
            h=h+mu*e(n)*x_buff;
        elseif(choose==2)%znormalizowany LMS
            energy=x_buff'*x_buff;
            h=h+mu/(gamma+energy) * e(n)* x_buff;
        end
    end
end

% x-sugnał wejściowy
%d-sygnał odniesienia
%M-liczba współczynników filtru adaptacyjnego
%mu-współczynnik uczenia 
% zwracane dane h-wektor końcowych współczynników 
%e- wktor błędów w czasie
%Uczenie oparte na prostej regule LMS: korekta proporcjonalna do błędu i sygnału wejściowego.
%Uczenie z normalizacją względem energii sygnału wejściowego – zapewnia większą stabilność 
% i niezależność od mocy sygnału