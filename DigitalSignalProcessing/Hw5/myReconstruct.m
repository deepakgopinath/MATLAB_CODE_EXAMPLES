% MUSI 6202 HW5 - Reconstruct signal
% CW @ GTCMT 2015
% objective: reconstruct blocks into a signal vector using OLA
% x = myReconstruct(xmat, windowSize, hopSize)
% xmat = float, windowSize*numBlocks matrix of signal
% windowSize = int, window size in samples
% hopSize = int, hop size in samples
% x = float, N*1 vector of input signal

function y = myReconstruct(xmat, windowSize, hopSize) 

numBlocks = size(xmat,2);
targetL = numBlocks*windowSize - (numBlocks - 1)*(windowSize-hopSize);
y = zeros(targetL, 1);
index = 1;
for i=1:numBlocks
    y(index:index+windowSize-1) = y(index:index+windowSize-1) + xmat(:,i);
    index = index + hopSize;
end
end

