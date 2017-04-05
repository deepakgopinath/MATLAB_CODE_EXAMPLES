% MUSI 6202 HW3 - all-pass filter
% CW @ GTCMT 2015
% objective: implement all-pass filter based on MUSI6202-slides-8.pdf p.55
% y = myAllpass(x, fs, g, delayInSec)
% x = N*1 vector, input signal
% fs = float, sampling frequency in Hz
% g  = float, feedback & feedforward gain
% delayInSec = float, delay time in second


function y = myAllpass(x, fs, g, delayInSec)

% initialization
N = length(x);
y = zeros(N, 1);

M = floor(delayInSec*fs); % to avoid fractional delay
for i=1:M
    y(i) = g*x(i);
end

for i=M+1:N
    y(i) = g*x(i) + x(i-M) - g*y(i-M);
end

end

% write your code here
