% MUSI 6202 HW5 - Naive phase update
% CW @ GTCMT 2015
% objective: update phase using naive estimation described in class
% phasMat_new = myNaivePhase(phasMat, hopSize, si)
% phasMat = float, windowSize*numBlocks matrix of phase
% hopSize = int, original hopSize
% si = internal time stretching factor
% phasMat_new = float, windowSize*numBlocks matrix of updated phase

function [phasMat_new] = myNaivePhase(phasMat, hopSize, si)

blockSize = size(phasMat, 1);
numBlocks = size(phasMat, 2);
phasMat_new = zeros(blockSize, numBlocks);
phasMat_new(:,1) = phasMat(:,1);
kVec = (0:1:blockSize-1)';
deltaPhi = ((2*pi*round(hopSize*si))/blockSize).*kVec;
for i=2:numBlocks
    phasMat_new(:,i) = phasMat_new(:,i-1) + deltaPhi;
    phasMat_new(:,i) = phasMat_new(:,i) + pi;
    phasMat_new(:,i) = mod(phasMat_new(:,i), 2*pi);
    phasMat_new(:,i) = phasMat_new(:,i) - pi;
end



end