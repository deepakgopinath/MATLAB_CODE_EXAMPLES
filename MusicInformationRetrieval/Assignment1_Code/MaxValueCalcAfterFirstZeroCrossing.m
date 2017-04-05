%A function which would iterate through a matrix and find the first peak
%after the first zero crossing from all the rows. Used in conjunction with
%freqDomainACF

%Submitted by Deepak Gopinath -  903014581
function [indexArray, nOfRows ] = MaxValueCalcAfterFirstZeroCrossing(ACFMatrix)

% so after freqDomainACF the returned matrix is send to this for max value after

rows = size(ACFMatrix, 1);
n = 1;

indexForEachBlock = [];
while n <= rows
    indexForEachBlock(n) = ZeroCrossingandMax(ACFMatrix(n,:));  
    n = n + 1;
end

indexArray = indexForEachBlock;
nOfRows = rows;

end

