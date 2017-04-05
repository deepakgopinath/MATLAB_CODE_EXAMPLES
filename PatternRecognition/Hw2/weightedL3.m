function [ output_args ] = weightedL3(a,b)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

output_args = 3*abs(a(1) - b(1)) + 2*abs(a(2) - b(2));
end

