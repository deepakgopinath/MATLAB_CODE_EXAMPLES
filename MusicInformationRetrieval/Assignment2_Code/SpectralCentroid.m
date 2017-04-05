function [ specCentroidVec ] = SpectralCentroid( samples, blockSize, hopSize )


%This function calculates the Spectral Centroid for each block for an audio file and returns
%a row vector.

L = length(samples);

n = 1;
specCentroidVec = []; 
kVector = 0:1:blockSize/2-1; %row
kVector = kVector'; %column

index = [];
for n=1:hopSize:L-blockSize
    
    currentBlock = samples(n:n+blockSize-1);
    fftCurrentBlock = fft(currentBlock,blockSize);
    absFFTCurrentBlock = abs(fftCurrentBlock(1:blockSize/2));
    if(sum(absFFTCurrentBlock) == 0) %look for silences in the audiofiles and account for it by setting the feature to be equal to zero; 
           currentVsc = 0;
           specCentroidVec = [specCentroidVec currentVsc];
           index = [index n]; 
           continue; 
     end
    kMultipliedMagnitude = kVector.*(absFFTCurrentBlock.^2);
    currentVsc = sum(kMultipliedMagnitude)/sum((absFFTCurrentBlock.^2)); %scalar
  
    specCentroidVec = [specCentroidVec currentVsc]; %row vector
    index  = [index n]; %for keeping track of the blocknumber

end

plot(index, specCentroidVec,'Color', 'red');


end

