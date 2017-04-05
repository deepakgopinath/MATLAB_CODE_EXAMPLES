function [ featureMatrix ] = GetFeatureMatrix( audioFileSamples, blockSize, hopSize)

%This function evaluates block wise feature calculation for each audio
%file.

VSc = SpectralCentroid(audioFileSamples,blockSize,hopSize);
VMEnv = MaxEnv(audioFileSamples, blockSize, hopSize);
VZc = ZeroCrossingRate(audioFileSamples, blockSize, hopSize);
VSpecCrest = SpectralCrest(audioFileSamples, blockSize, hopSize);
VSpecFlux = SpectralFlux(audioFileSamples, blockSize, hopSize);

featureMatrix = [VSc; VMEnv; VZc; VSpecCrest; VSpecFlux]; % 5 rows, columns = number of blocks per audiofile.

end

