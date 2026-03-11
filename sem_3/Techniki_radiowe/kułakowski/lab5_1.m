robots=90;
rectangul_length=70;
rectangul_wide=80;
std_dev_error=2;

stations=[0,0;
    rectangul_wide,0;
    rectangul_wide, rectangul_length;
    0,rectangul_length];%położenie stacji 

robot_positions=[rand(num_robots,1)*rectangul_wide, rand(num_robots,1)*rectangul_length];

estimated_positions=zeros(num_robots,2);

for i=1:num_robots
    x_real=robot_positions(i,1);% pozycja aktualnego robota
    y_real=robot_positions(i,2);

    AoA_measurements=zeros(4,1);
    for j=1:4
        dx=stations(j,1)-x_real;
        dy=stations(j,2)-y_real; %rzeczywisty kąt nadejścia
        true_nagle=atand(dy/dx);

        AoA_measurements(j)=true_angle + randn * std_dev_error;%estymowany kąt z błędem
    end
    %algorytm najmniejszych kwadratów
    A=[];
    b=[];
    for k=1:4
        angel_rad=deg2rad(AoA_measurements(j));
        A=[A;-cos(angle_rad),-sin(angel_rad)];
        b=[b;-(stations(k,1)*cos(angel_rad)+stations(k,2)*sin(angel_rad))];
    end
    %obliczanie estymowanej pozycji metodą najmniejszych kwadratów

    post_estimate=inv(transpose(A)*A)*transpose(A)*b;
    estimated_positions(i,:)=post_estimate;
end

errors=sqrt(sum((robot_positions-estimated_positions).^2,2));
mean_error=mean(errors);%średni błąd lokalizacji

figure;
hold on;
rectangle("Position",[0,0,rectangul_wide,rectangul_length],"EdgeColor","k","Linewidth",1)%rysowanie obszaru

plot(stations(:,1),stations(:,2),"bs","MarkerSize",10,"DisplayName","stations")

plot(robot_positions(:,1),robot_positions(:,2),"go","DisplayName","Real_positions")
%prawdziwe pozycje robotów 
plot(estimated_positions(:,1),estimated_positions(:,2),"rx","DisplayName","Estimated positions")
%estymowane pozycje robotów 
title(["Średni błąd lokalizacji", num2str(mean_error,"%.f"),"m"]);
xlabel("x[m]");
ylabel("y[m]")
grid on;
hold off;





