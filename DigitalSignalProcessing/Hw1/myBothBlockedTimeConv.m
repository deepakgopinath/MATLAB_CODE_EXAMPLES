% MUSI 6202 HW1(v) Time domain convolution both signal and IR blocked
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement fast convolution (using time domain
%            operation) as described in Zolzer 2008 p165
% y = myBothBlockedTimeConv(x, h, M)
% x: xLen*1 vector of input sequence
% h: hLen*1 vecotr of impulse response
% y: (xLen+hLen-1)*1 vector of output sequence

function y = myBothBlockedTimeConv(x, h, blockLength)

% initialization 
tic;
y = [];
if(blockLength <= 0 || (floor(blockLength) == blockLength) ~= 1) %check for negative or non-integer blocklengths
   disp('Please enter a valid blockLength');
   return;
end
L = size(x, 1);
M = size(h, 1);
originalL = L;
originalM = M;

%deal with cases when the blocklength is greater than the input signals.
if(blockLength > L)
   x = [ x ; zeros(blockLength-L, 1)];
   L = size(x, 1); %reassign the length. 
end

if(blockLength > M)
   h = [h ; zeros(blockLength-M, 1)];
   M = size(h, 1);
end

numLastBlock = mod(L,blockLength); %to check for the last block. 
if(numLastBlock ~= 0)
   x = [x ; zeros(blockLength - numLastBlock, 1)]; %zero pad to complete the last block
end

numLastBlock = mod(M,blockLength);
if(numLastBlock ~= 0)
   h = [h ; zeros(blockLength - numLastBlock, 1)]; %zero pad to complete the last block
end

L = size(x, 1); %the modified length
M = size(h, 1); %the modified length of impulse Response
y = zeros((L + M -1), 1);
indexI = 1;
for i=1:blockLength:L
    xBlock = x(i:i+blockLength-1);
    indexJ = 1;
    for j=1:blockLength:M
        hBlock = h(j:j+blockLength-1);
        index = indexI+indexJ-1;
        yBlock = myTimeConv(xBlock,hBlock);
        y(blockLength*(index - 1) + 1: blockLength*(index+1) - 1) = y(blockLength*(index - 1) + 1: blockLength*(index+1) - 1) + yBlock;
        indexJ = indexJ + 1;
    end
    indexI = indexI + 1;
end

y = y(1:originalL + originalM - 1); %remove trailing zeros
toc;

% ==== write your codes here:
