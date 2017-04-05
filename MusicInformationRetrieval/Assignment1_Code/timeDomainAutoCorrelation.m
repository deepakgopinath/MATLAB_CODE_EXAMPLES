function [ output_args ] = timeDomainAutoCorrelation(file, windowSize, hopSize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

samples = audioread(file);
L = length(samples);
n = 1;
index =[];
h=waitbar(0,'Please wait..');
blockAutoCorr = []; 
matrixAutoCorr = [];% there will fileSize/hopsize number of row and 2*windowSize - 1 columns in this matrix
etaArray = 0:1:windowSize-1; % row. these are the lags to be used. symmetrical about the center. so only calculate right side.
while(n < L-windowSize)
    waitbar(n/L)
    currentBlock = samples(n:n+windowSize-1); %column
    % the autocorrelation function should return at the end a 2d matrix.
    % each row or column representing each block. and the other dimension
    % representing the eta parameter. 
    
    % For every block the autocorrelation needs to be calculated for all
    % the lags. 
    zerosForPadding = zeros(windowSize-1, 1); %column
    ZeroPaddedCurrentBlock = [currentBlock; zerosForPadding]; % column 
    i = 1;
    while(i <= size(etaArray,2))
        currentEta = etaArray(i);
        movingBlock = ZeroPaddedCurrentBlock(currentEta+1:currentEta+windowSize); %column
        blockAutoCorr = [blockAutoCorr sum(currentBlock.* movingBlock)];   %row
        i =  i + 1;
    end
    blockAutoCorr = [fliplr(blockAutoCorr(2:length(blockAutoCorr))) blockAutoCorr]; %mirror image of right hand side on left hand side
    matrixAutoCorr = [matrixAutoCorr ; blockAutoCorr]; % each row contains the correlatin for each block length of each is 2*windowSize - 1
    blockAutoCorr = [];
    index = [index n];
    n = n +  hopSize;
end

xAxisForAutoCorr = index;
yAxisForAutoCorr = 1-windowSize:1:windowSize-1; %paramater m for the autocorrelation function
close(h)
imagesc(xAxisForAutoCorr, yAxisForAutoCorr, matrixAutoCorr);
axis xy;view(0,90);

end

