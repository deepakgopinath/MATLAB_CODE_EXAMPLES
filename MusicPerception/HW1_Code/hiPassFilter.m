function [ filteredData ] = hiPassFilter(X)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

a0h = 1;
a1h = -1.99004745483398;
a2h = 0.99007225036621;
b0h = 1.0;
b1h = -2.0;
b2h = 1.0;

bh = [b0h, b1h, b2h];
ah = [a0h,a1h, a2h];

filteredData = filter(bh,ah,X);

end

