function [ y ] = transform( x )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% x is 2d data;
y = zeros(6,1);
x1 = x(1);
x2 = x(2);

y(1) = x1*x1;
y(2) = x2*x2;
y(3) = 1;
y(4) = sqrt(2)*x1;
y(5) = sqrt(2)*x2;
y(6) = sqrt(2)*x1*x2;



end

