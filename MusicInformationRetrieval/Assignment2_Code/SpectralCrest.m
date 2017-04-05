function [ SpectralCrestVec ] = SpectralCrest(samples, blockSize, hopSize )

%This function calculates the Spectral Crest for each block and returns
%a row vector.

L = length(samples);

n = 1;
SpectralCrestVec = [];
index = [];

for n=1:hopSize:L-blockSize
    
    currentBlock = samples(n:n+blockSize-1);
    fftCurrentBlock = fft(currentBlock, blockSize);
    absFFTCurrentBlock = abs(fftCurrentBlock(1:blockSize/2));
    
     if(sum(absFFTCurrentBlock) == 0) %look for silences in the audiofiles and account for it by setting the feature to be equal to zero;
         currentSpecCrestVal = 0;
         SpectralCrestVec = [SpectralCrestVec currentSpecCrestVal]; 
         index = [index n];
         continue;
     end
    currentSpecCrestVal = max(absFFTCurrentBlock)/sum(absFFTCurrentBlock);
    SpectralCrestVec = [SpectralCrestVec currentSpecCrestVal]; 
    index = [index n];
end

plot(index, SpectralCrestVec, 'Color', 'red');

end

