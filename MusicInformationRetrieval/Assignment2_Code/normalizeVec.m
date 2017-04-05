function [ normVec ] = normalizeVec( inputVec)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

mBc = mean(inputVec);
stdBC = std(inputVec);

normVec = (inputVec - mBc)/stdBC;

end

