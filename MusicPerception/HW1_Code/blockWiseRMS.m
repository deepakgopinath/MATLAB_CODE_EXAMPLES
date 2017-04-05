function [rmsMatrix ] = blockWiseRMS( samples, blockSize, hopSize )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% samples is the multichannel audio for which we need to evaluate blockwise
% RMS

if(size(samples, 2) > 2) % make sure the audio is in columan format
    samples = samples';
end

L = size(samples,1); % length of samples. 
rmsMatrix = zeros(1,size(samples, 2));
    for n=1:hopSize:L-blockSize
        currentBlockRMS = sqrt(sum(samples(n:n+blockSize,:).^2)/blockSize);
        rmsMatrix = [rmsMatrix ; currentBlockRMS];
    end
end

