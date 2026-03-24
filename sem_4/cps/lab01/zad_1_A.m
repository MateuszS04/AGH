clear all;
close all;

A=230;
f=50;
T=0.1;

fpr1=10000;%częstotliwość próbkowania
fpr2=500;
fpr3=200;

dt1=1/fpr1;
dt2=1/fpr2;
dt3=1/fpr3;

t1=0:dt1:T;
t2=0:dt2:T;
t3=0:dt3:T;

x1=A*sin(2*pi*f*t1);
x2=A*sin(2*pi*f*t2);
x3=A*sin(2*pi*f*t3);

figure;
plot(t1,x1,'b-');
hold on;
plot(t2,x2,'r-o');
plot(t3,x3,'k-x');


grid on;
xlabel('czas [s]');
ylabel('napięcie [V]');
