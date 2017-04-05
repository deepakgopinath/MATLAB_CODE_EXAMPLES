function [ filteredData ] = shelvingFilter(X)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

a0 = 1;
a1 = -1.69065929318241;
a2 = 0.73248077421585;

b0 = 1.53512485958697;
b1 = -2.69169618940638;
b2 = 1.19839281085285;
b = [b0, b1, b2];
a = [a0, a1, a2];

filteredData = filter(b,a,X);

end

