% MUSI 6202 HW3 - IIR comb filter
% CW @ GTCMT 2015
% objective: implement an IIR comb filter with Ring Buffer
%            based on MUSI6202-slides-8.pdf p.54, MUSI6202-slides-8.pdf p.16.
% y = myIirComb(x, fs, FB, FF, delayInSec)
% x = N*1 vector, input signal
% fs = float, sampling frequency in Hz
% FB = float, feedback gain
% FF = float, feedforward gain
% delayInSec = float, delay time in second

function y = myIirComb(x, fs, FB, FF, delayInSec)


% initialization 
N = length(x);
y = zeros(N, 1);

M = floor(delayInSec*fs);
ringBuff = zeros(M+1, 1); % L = M+1, can be 2*M or any value
L = length(ringBuff);
readIdx = 1; %
writeIdx = M+1;

for i=1:N
    y(i) = FF*x(i) - FB*ringBuff(readIdx);
    ringBuff(writeIdx) = y(i);
    writeIdx = mod(writeIdx,L) + 1;
    readIdx = mod(readIdx,L) + 1;
    
end


% write your code here:


