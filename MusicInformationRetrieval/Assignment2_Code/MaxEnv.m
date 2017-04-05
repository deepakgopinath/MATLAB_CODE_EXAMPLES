function [  MaxEnvVec] = MaxEnv( samples, blockSize, hopSize )

%This functions calculate the peak Envelope in each block and returns a
%vector containing all the peak envelopes for the audiofile. 
L = length(samples);

n = 1;
MaxEnvVec = [];
index = [];

for n=1:hopSize:L-blockSize
        
    currentBlock = abs(samples(n:n+blockSize-1));
    MaxEnvVec = [MaxEnvVec max(currentBlock)]; 
    index = [index n];
end

plot(index, MaxEnvVec, 'Color', 'red');

end

