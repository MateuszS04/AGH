c=3e8;
v=30;%speed of transmitter

start=[50,10]; %pozycja poczatkowa
finish=[50,300]; %pozycja koncowa

tx_power=5;%moc
tx_pos=[110,190];%pozycja nadajnika

freq=3e9;
lambda=c/freq;%dlugosc fali

wall_1_start=[20,30];% first wall
wall_1_end=[20,300];

wall_2_start=[70,100];%second wall
wall_2_end=[130,100];

reflection_coeff=0.8;

t_total=6;
dt=0.01;
t=0:dt:t_total;%time vector

user_positions=[start(1)*ones(size(t));start(2)+v*t];

Pr_direct=zeros(size(t));
Pr_reflected1=zeros(size(t));
Pr_reflected2=zeros(size(t));

function d=distance(p1,p2)
d=sqrt((p1(1)-p2(2))^2+(p1(2)-p2(2))^2);
end
%counting the power of the signal

for i=1:length(t)
    user_pos=user_positions(i,:);

    d_directly=distance(tx_pos,user_pos);
    Pr_direct(i)=tx_power*(lambda/(4*pi*d_directly))^2;

    reflection_point1=[wall_1_start(1),user_pos(2)];%reflection from the wall point
    if reflection_point1(2)>=wall_1_start(2) && reflection_point1(2)<=wall_1_end(2)
        d_reflect_1=distance(tx_pos,reflection_point1)+distance(reflection_point1,user_pos);
        Pr_reflected1=reflection_coeff*tx_power*(lambda/(4*pi*d_reflect_1))^2;
    end

    reflection_point2=[user_pos(1),wall_2_start(1)];
    if reflection_point2(1)>=wall_2_start(1) && reflection_point2(1)<=wall_2_end(1)
        d_reflect_2=distance(tx_pos,reflection_point2)+distance(reflection_point2,user_pos);
        Pr_reflected2=reflection_coeff*tx_power*(lambda/(r*pi*d_reflect_2))^2;
    end
end
Pr_total = Pr_direct + Pr_reflected1 + Pr_reflected2;

% Wykres
figure;
plot(t, 10*log10(Pr_direct), 'b', 'DisplayName', 'Sygnał bezpośredni');
hold on;
plot(t, 10*log10(Pr_reflected1), 'r--', 'DisplayName', 'Odbicie od ściany 1');
plot(t, 10*log10(Pr_reflected2), 'g--', 'DisplayName', 'Odbicie od ściany 2');
plot(t, 10*log10(Pr_total), 'k', 'DisplayName', 'Sygnał całkowity');
xlabel('Czas [s]');
ylabel('Moc sygnału [dB]');
legend;
title('Moc sygnału odbieranego przez użytkownika');
grid on;


