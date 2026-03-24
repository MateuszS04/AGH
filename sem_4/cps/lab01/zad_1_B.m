clear all;
close all;

A=230;
f=50;
T=1;

fpr1=10000;%częstotliwość próbkowania w Hz
fpr2=51;
fpr3=50;
fpr4=49;

% fpr2=26;
% fpr3=25;
% fpr4=24;

dt1=1/fpr1;
dt2=1/fpr2;
dt3=1/fpr3;
dt4=1/fpr4;

t1=0:dt1:T;
t2=0:dt2:T;
t3=0:dt3:T;
t4=0:dt4:T;

x1=A*sin(2*pi*f*t1);
x2=A*sin(2*pi*f*t2);
x3=A*sin(2*pi*f*t3);
x4=A*sin(2*pi*f*t4);

figure;
plot(t1,x1,'b-');
hold on;
plot(t2,x2,'g-o');
plot(t3,x3,'r-o');
plot(t4,x4,'k-o');


grid on;
xlabel('czas [s]');
ylabel('napięcie [V]');