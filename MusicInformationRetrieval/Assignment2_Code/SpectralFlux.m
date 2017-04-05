function [ SpectralFluxVec ] = SpectralFlux( samples, blockSize, hopSize  )


samples = [zeros(hopSize,1); samples]; %zero pad the samples, we need this so that the previous block is of the same length during the first iteration
n = hopSize+1;
L = length(samples);
SpectralFluxVec = [];
index = [];
div = blockSize/2;
np = 0;

while n <=L-blockSize

    np = n - hopSize;
    nextBlock = samples(n:n+blockSize-1);
    previousBlock = samples(np:np+blockSize-1);
    
    fftPrevious = fft(previousBlock, blockSize);
    fftNext = fft(nextBlock, blockSize);
        
    absFP = abs(fftPrevious(1:blockSize/2));
    absFN = abs(fftNext(1:blockSize/2));
    
    SqrtOfSumOfSquaredDiff = sqrt(sum((absFN - absFP).^2));
    
    SpectralFluxVec = [SpectralFluxVec SqrtOfSumOfSquaredDiff/div];
    
    n = n + hopSize;
    index = [index n];
end

plot(index, SpectralFluxVec, 'Color', 'red');
end

