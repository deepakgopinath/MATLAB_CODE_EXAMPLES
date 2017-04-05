% MUSI 6202 HW5 - Group phases
% CW @ GTCMT 2015
% objective: Group updated phase according magnitude peaks
% phasMat_new = myGroupPhase(phasMat, hopSize, si, magnMat, numPeaks, spread)
% phasMat = float, windowSize*numBlocks matrix of phase
% hopSize = int, original hopSize
% si = internal time stretching factor
% magnMat = float, windowSize*numBlocks matrix of magnitude
% numPeaks = int, number of peaks to track for phase grouping
% spread = int, number of neighboring bins to group with
% phasMat_new = float, windowSize*numBlocks matrix of updated phase


function [phasMat_new] = myGroupPhase(phasMat, hopSize, si, magnMat, numPeaks, spread)

blockSize = size(phasMat, 1);
numBlocks = size(phasMat, 2);
phasMat_new = zeros(blockSize, numBlocks);
phasMat_new(:,1) = phasMat(:,1);

[y, loc] = findpeaks(magnMat(:,1), 'SortStr', 'descend');
% loc = sort(loc(1:min(numPeaks, length(loc))), 'ascend'); %so that for conflicting bins the bin with higher magnitude will override the lower bins
loc = flipud(loc(1:min(numPeaks, length(loc))));
kVec = (0:1:blockSize-1)';
deltaPhi = ((2*pi*round(hopSize*si))/blockSize).*kVec;

for i=1:length(loc)
    centerBin = loc(i);
    for j=centerBin-spread:centerBin+spread
        currentBin = max(1,j); 
        currentBin = min(currentBin, blockSize);
        phasMat_new(currentBin, 1) = phasMat_new(centerBin, 1);
    end
end

for k=2:numBlocks
    phasMat_new(:,k) = phasMat_new(:,k-1) + deltaPhi;
    phasMat_new(:,k) = phasMat_new(:,k) + pi;
    phasMat_new(:,k) = mod(phasMat_new(:,k), 2*pi);
    phasMat_new(:,k) = phasMat_new(:,k) - pi;
    [y, loc] = findpeaks(magnMat(:,k), 'SortStr', 'descend');
%     loc = sort(loc(1:min(length(loc),numPeaks)), 'ascend');
    loc = flipud(loc(1:min(numPeaks, length(loc)))); % to make sure that if there are overlaps the peaks with higher magnitude will get preference
    for i=1:length(loc)
        centerBin = loc(i);
        for j=centerBin-spread:centerBin+spread
            currentBin = max(1,j); 
            currentBin = min(currentBin, blockSize);
%             fprintf('CurrBin and centerBin = %d %d\n', currentBin, centerBin);
            phasMat_new(currentBin, k) = phasMat_new(centerBin, k);
        end
    end   
end
end