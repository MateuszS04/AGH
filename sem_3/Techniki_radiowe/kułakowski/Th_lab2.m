room_length=28;%size of the room in[m]
room_wide=16;
door_start=10;
door_end=13;
wall_y=20.05;%door placemant on the y-axis

freq=3.6e9;
lambda=3e8/freq;%wave lenght

tx_pos=[12.05, 7.05];%transmitter power
tx_power=5;%[mW]

reflection_coeff=0.7;
% receiver net (by 0.1 m) 
[x,y]=meshgrid(0:0.1:room_wide,0:0.1:room_length);
[rows,cols]=size(x);

%matrix of received power
received_power=zeros(rows,cols);

function los = check_l_o_s(tx_pos,rx_pos,partition_y,door_start,door_end)
%begining and end of wall
    wall_start=[0,partition_y];
    wall_end=[16,partition_y];

    result=dwawektory(tx_pos(1),tx_pos(2),rx_pos(1),rx_pos(2),wall_start(1),wall_start(2),wall_end(1),wall_end(2));

    if result==1
        door_result=dwawektory(tx_pos(1),tx_pos(2),rx_pos(1),rx_pos(2),door_start,partition_y,door_end,partition_y);
        if door_result==1 || door_result==0
            los=true; %radius cross the door
        else
            los=false;% radius cross the wall but not thru the wall
        end
    else 
        los=true;%radius don't cross the wall
    end
end
%the received power

for i=1:rows
    for j=1:cols
        rx_pos=[x(i,j),y(i,j)];%position of the reciver
        %check if it croos the door or not
        if check_l_o_s(tx_pos,rx_pos,partition_y,door_start,door_end)
            %distance between reciver and transmitter
            d=sqrt((tx_pos(1)-rx_pos(1))^2+(tx_pos(2)-rx_pos(2))^2);
            %path loss
            path_loss = (lambda / (4 * pi * d))^2;
            received_power(i,j)=tx_power*path_loss;
        else
            received_power(i,j)=0;%no signal
        end
    end
end

figure;
pcolor(x,y,10*log10(received_power));%the power converted to dbm
shading interp;
colorbar;
xlabel('x[m]')
ylabel('y[m]')


