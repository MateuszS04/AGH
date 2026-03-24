% bity_mantysy.m
clear all; close all;

% Double-precision mantissa
e = 1/2; 
n = 0; 
while ( (1+e) > 1 ) 
    e = e/2; 
    n = n + 1; % If so, halve "e" and increase the bit count
end
nbits_double = n; 
disp("double-precision : " + nbits_double);

% Single-precision mantissa
e = single(1/2); 
n = 0; 
while ( (1+e) > 1 ) 
    e = e/2; 
    n = n + 1;
end
nbits_single = n; 
disp("single-precision : " + nbits_single);
