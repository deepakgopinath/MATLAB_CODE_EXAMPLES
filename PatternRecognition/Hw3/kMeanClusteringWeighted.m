function [ centroids, classLabels  ] = kMeanClusteringWeighted(data, k, covMegaMatrix, EucCentroids)

%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

newCentroids = EucCentroids; % k by 4
dataPoint = zeros(k, size(data, 2));
newLabels = zeros(size(data, 1), 1);
distVec = zeros(k, 1);
maxiter=10;

for iter = 1:maxiter
    for i=1:size(data,1)
        dataPoint = repmat(data(i,:), k, 1);
        diffXandMean = dataPoint - newCentroids; %row vectors
        for j=1:k
           distVec(j) = sqrt(diffXandMean(j, :)*inv(covMegaMatrix(:,:,j))*diffXandMean(j, :)');
%              distVec(j) = sqrt(diffXandMean(j, :)*diffXandMean(j,:)' + trace(covMegaMatrix(:,:,j)));
        end
        newLabels(i) = min(find(distVec == min(distVec)));
    end
    for j=1:k
        covMegaMatrix(:,:,j) = cov(data(find(newLabels == j),:));
%          newCentroids(j, :) = (inv(covMegaMatrix(:,:,j)) * (mean(data(find(newLabels == j), :), 1))')';
        newCentroids(j, :) = mean(data(find(newLabels == j), :),1);
    end 
end
centroids = newCentroids;
classLabels = newLabels;
end