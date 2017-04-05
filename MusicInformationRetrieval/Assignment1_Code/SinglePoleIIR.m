%Single Pole IIR Filter. Q2-2

%Submitted by Deepak Gopinath - 903014581

function [ filtered ] = SinglePoleIIR( b, a, X )

%single pole IIR filter implementation. b is the feedforward coeff and a is
%the feedback coeff.

L = length(X);
n = 1;
Alpha = -a;
OneMinusAlpha = b;
output = [];
output(1) = 0; % zero initial conditions; 
n = 2;
while n <= L 
    output(n) = X(n)*OneMinusAlpha + Alpha*output(n-1); %Recursive implementation.
    n = n + 1;
end

%Listen to the sounds

sound(X, 44100);
pause on;
pause(3);
sound(output, 44100);
pause(3);
pause off;

filtered = output;
end

