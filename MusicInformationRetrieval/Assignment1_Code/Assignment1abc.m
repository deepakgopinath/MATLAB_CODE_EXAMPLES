%Assignment 1 a, b, c
%Deepak Gopinath - 903014581


function [ output_args ] = Assignment1abc( file, windowSize, hopSize )

%Function to calculate blockbased autocorrelation using matlab's xcorr
%function and then plot the original waveform, spectrogram and correlation
%function. 

[samples, sr2] = audioread(file); % this is a column vector
L = length(samples);
n = 1;
index = [];
blockAutoCorr = []; %allocate an empty array.

% for every block of size windowSize xcorr will give a vector of size
% 2*windowSize - 1. 

while(n <= L-windowSize)
    
    currentBlock = samples(n : n+windowSize-1);
    currentBlockAutoCorr = xcorr(currentBlock, 'none'); % this is a column vector of size 2*(windowSize) - 1
    blockAutoCorr = [blockAutoCorr  currentBlockAutoCorr]; % This appends column vectors. the number of column will be equal to the number of times this loop runs which is equal to filesize/hopsize
    index = [index n];
    n = n + hopSize;
end


 %Plotting the waveform itself.

 subplot(3,1,1);
 xAxisForFilePlot = (0:1:L-1)*1/sr2;
 plot(xAxisForFilePlot, samples, 'Color', 'blue');
 xlabel('Time');
 ylabel('Amplitude');

 %Plotting the spectrogram
 subplot(3,1,2);
 spectrogram(samples, hamming(256), 128);
 subplot(3,1,3);

% the 3d plot can have index on x axis, 0-(2*windowSize - 1) on second
% and the blockAutoCorr matrix values on the z axis
 xAxisForAutoCorr = index/sr2;
 yAxisForAutoCorr = 1-windowSize:1:windowSize-1; %paramater eta for the autocorrelation function
 imagesc(xAxisForAutoCorr, yAxisForAutoCorr, blockAutoCorr);
 xlabel('Time');
 ylabel('Eta - No:of samples');
 colorbar;
end


