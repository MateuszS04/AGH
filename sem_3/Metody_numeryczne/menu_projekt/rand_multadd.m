function s=rand_multadd( N, seed )
a = 69069;
m = 5;
p = 2^32;
s = zeros(N,1);
for i=1:N
s(i) = mod(seed*a+m,p);%wzór generatora kongruenthnego
seed = s(i);%punkt startu dla generatora liczb 
end
s = s/p;


% function s=rand_multadd( N, seed ) %%Borland C/C++
% a = 22695477;
% m = 1;
% p = 2^32;
% s = zeros(N,1);
% for i=1:N
% s(i) = mod(seed*a+m,p);%wzór generatora kongruenthnego
% seed = s(i);%punkt startu dla generatora liczb 
% end
% s = s/p;
% 
% function s=rand_multadd( N, seed )%Borland Delphi virtual Pascal
% a = 134775813;
% m = 1;
% p = 2^32;
% s = zeros(N,1);
% for i=1:N
% s(i) = mod(seed*a+m,p);%wzór generatora kongruenthnego
% seed = s(i);%punkt startu dla generatora liczb 
% end
% s = s/p;

% function s=rand_multadd( N, seed )%ANSI C
% a = 1103515245;
% m = 12345;
% p = 2^32;
% s = zeros(N,1);
% for i=1:N
% s(i) = mod(seed*a+m,p);%wzór generatora kongruenthnego
% seed = s(i);%punkt startu dla generatora liczb 
% end
% s = s/p;