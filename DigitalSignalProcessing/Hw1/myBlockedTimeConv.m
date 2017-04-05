% MUSI 6202 HW1(iii) blocked Time domain convolution 
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement time domain convolution 
%            with signal partiioned into non-overlapping blocks
% y = myBlockedTimeConv(x, h)
% x: N*1 vector of input sequence
% h: M*1 vecotr of impulse response
% y: (N+M-1)*1 vector of output sequence

function y = myBlockedTimeConv(x, h)

% initialization
tic;
L = size(x, 1);
M = size(h, 1);
y = zeros((L+M-1), 1);

numLastBlock = mod(L,M);
if(numLastBlock ~= 0)
   x = [x ; zeros(M - numLastBlock, 1)]; %zero pad to complete the last block
end
y = zeros((length(x) + M - 1), 1);
index = 1;
for i=1:M:length(x)
    xBlock = x(i:i+M-1);
    yBlock = myTimeConv(xBlock, h);
    y(M*(index-1) + 1: M*(index+1) - 1) = y(M*(index-1) + 1: M*(index+1) - 1) + yBlock;
    index = index + 1;
end
y = y(1:L+M-1); %remove trailing zeros;
toc;

% ==== write your codes here:













