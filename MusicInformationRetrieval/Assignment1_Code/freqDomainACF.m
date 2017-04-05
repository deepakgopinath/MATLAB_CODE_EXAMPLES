%Implementation of frequency domain auto correlation function
%Blockwise Correlation - Q1-e

%Submitted by Deepak Gopinath- 903014581

function [ output_args ] = freqDomainACF( file, windowSize, hopSize)

%Implementation of the frequency domain block wise auto correlation
%function making use of the Wiener - Khinchin function;

[samples, sr] = audioread(file); %column
L = length(samples);

n = 1;
index = [];
matrixAutoCorr = [];
count = 1;
h=waitbar(0,'Please wait..');

while n <=  L-windowSize
    waitbar(n/L)
    currentblock = samples(n:n+windowSize-1); %column
    mag = abs(fft(currentblock,2^nextpow2(2*length(currentblock)-1))).^2; %column - fftsize is greater than the size of the signal.
    %The Fft size is equal 2*windowSize - 1 (to match the dimensions of a correlation functions)
    acf = ifft(mag); % of length 2L-1 
    
    matrixAutoCorr(count , :) = acf(1:length(currentblock))'; %only take half the acf vector and then later on make a mirror image and prepend it to the matrix
    % each row is of length windowsize and number of rows will be equal to the number of time the block calculation happens
    index = [index n];
    n = n + hopSize;
    count = count + 1;
end

temp = matrixAutoCorr; %temporary storage so that it can be returned. 
matrixAutoCorr = [fliplr(matrixAutoCorr(:, (2:size(matrixAutoCorr,2)))) matrixAutoCorr]; % mirror image and append to get negative values. 

 close(h)
 subplot(3,1,1);
 xAxisForFilePlot = (0:1:L-1)*1/sr;
 plot(xAxisForFilePlot, samples, 'Color', 'blue');
 xlabel('Time');
 ylabel('Amplitude');
 
 subplot(3,1,2);
 spectrogram(samples, hamming(256), 128);
 
 subplot(3,1,3);
 xaxis = index/sr;
 yaxis = 1-windowSize:1:windowSize-1;
 imagesc (xaxis, yaxis, matrixAutoCorr');
 xlabel('Time');
 ylabel('Eta - No:of samples');
 colorbar;

 output_args = temp;

end

