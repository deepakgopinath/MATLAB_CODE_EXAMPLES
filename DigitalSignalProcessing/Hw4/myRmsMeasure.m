% MUSI 6202 HW4 - level measurement: RMS measurement
% CW @ GTCMT 2015
% objective: implement a 1st order RMS measurement
% xRms = myRmsMeasure(x, fs, tm)
% x = float N*1 vector, input signal
% fs = float, sampling frequency (Hz)
% tm = float, averaging time (ms)
% xRms = float N*1 vector, output signal

function xRms = myRmsMeasure(x, fs, tm)

% initialization 
N = length(x);
xRms = zeros(N, 1);

% write your code here
Ts = 1/fs;
if(tm ~= 0)
    TAV =  1 - exp((-2.2*Ts)/(tm/1000));
else
    TAV = 1;
end

for i=1:N
    xRms(i) = sqrt((xRms(max(i-1,1))^2)*(1 - TAV) + TAV*(x(i)^2));    
end



