clear all;
close all;

std_1=[];
std_2=[];
vector_a=[];

for a=-1:0.001:1
    x_1=[];
    x_2=[];
    for epsi=0.001:0.0001:0.1
        A=[1,1;a,1];
        b=[1;1];

        A=A+epsi*randn(2,2);
        b=b+epsi*randn(1,2);
        x=inv(A)*b;
        x_1=[x_1,x(1)];
        x_2=[x_2,x(2)];
    end
    mean(x_1)
    mean(x_2)
    std_1=[std_1,std(x_1)];
    std_2=[std_2,std(x_2)];
    vector_a=[vec_a,a];
end
plot(vec_a,std_1,vec_a,std_2)
