function [ outputVec] = trimZeros( inputVec )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

copyInputVec =  inputVec;
[~, ix] = find(copyInputVec == 0);
copyInputVec(ix) = [];
outputVec = copyInputVec;
end

