%Implementation of time domain auto correlation function
%Blockwise Correlation - Q1-d
%Submitted by Deepak Gopinath- 903014581


function [ output_args ] = timeDomainACF( file, windowSize, hopSize )
%This function implements the time domain block wise auto correlation function
% This is the slowest of all the different implementations done as a part
% of the assignment.
[samples, sr] = audioread(file); %column
L = length(samples);

n = 1; % initializations
index = [];

matrixAutoCorr = [];
h=waitbar(0,'Please wait..'); %progress indicator
etaArray = 0:1:windowSize-1; %lag vector. row vector; We will calculate only for positive values and then mirror it to form the complete matrix
i = 1;
count = 1;


while n <= L-windowSize
    waitbar(n/L)
    isn = n; %start of the block
    ien = n + windowSize - 1; %end of the block
    i = 1;
    while i <= size(etaArray, 2) %number of columns in etaArray row vector
        currentEta = etaArray(i); %scalar- the lag factor
        matrixAutoCorr(count, i) = sum(samples(isn:ien - currentEta).*samples(isn+currentEta:ien)); % scalar - making the matrix element by element
        i = i + 1;
    end  
  count =  count + 1;
  index = [index n];
  n = n + hopSize;

end

matrixAutoCorr = [fliplr(matrixAutoCorr(:, (2:size(matrixAutoCorr,2)))) matrixAutoCorr]; %Make a mirror image of columns 2 till end and then prepend it to the existing matrix. Then it cover the whole range of 2L-1

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
end

