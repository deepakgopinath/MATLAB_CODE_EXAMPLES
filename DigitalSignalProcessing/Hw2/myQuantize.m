function y = myQuantize(x, w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

qNum= 2^w;
qStepSize = 2/qNum; %1/2^(w-1)
x = x*2^(w-1);
x = round(x);
x(x >= 2^(w-1)) = 2^(w-1) - 1; %Limit ranges
x(x < -2^(w-1)) = -2^(w-1);
y = x*qStepSize;

end

