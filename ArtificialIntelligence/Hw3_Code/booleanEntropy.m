function [ output ] = booleanEntropy( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if(x == 0 || x == 1)  %if 0 or 1 log will not be defined. taking care of boundary conditions
    output = 0;
else
    output = -(x*log2(x) + (1-x)*log2(1-x));
end
end

