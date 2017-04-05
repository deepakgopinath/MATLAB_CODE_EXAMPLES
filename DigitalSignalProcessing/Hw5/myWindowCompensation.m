function [ envelope ] = myWindowCompensation(windowSize, hopSize, numBlocks)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here


window = hann(windowSize, 'symmetric');
windowMatrix = repmat(window, 1, numBlocks);
envelope = myReconstruct(windowMatrix, windowSize, hopSize);

overlap = windowSize - hopSize;
envelope(1:overlap-1) = envelope(overlap)*ones(length(1:overlap-1),1); % flatten out the edges. 
envelope(end-overlap+1:end) = envelope(end-overlap)*ones(length(envelope(end-overlap+1:end)),1);
end