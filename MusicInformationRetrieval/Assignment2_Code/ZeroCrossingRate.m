function [ ZeroCrossingVec ] = ZeroCrossingRate(samples, blockSize, hopSize )
%This function calculates the Zero Crossing Rate for each block and returns
%a row vector.
L = length(samples);

n = 1;
ZeroCrossingVec = [];
index = [];
oneBy2K = 1/(2*blockSize); %Constant, scalar

for n=1:hopSize:L-blockSize
    currentBlock = samples(n:n+blockSize-1);
    signCurrentBlock = sign(currentBlock);
    currentBlockZCRate = oneBy2K*(sum(abs(signCurrentBlock(2:blockSize)-signCurrentBlock(1:blockSize-1))));
    ZeroCrossingVec = [ZeroCrossingVec currentBlockZCRate];
    index = [index n];
end

plot(index, ZeroCrossingVec, 'Color', 'blue');
end

