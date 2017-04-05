function [centroids, classLabels ] = kMeansClustering( data, k, distMetric, covMegaMatrix, eucCentroids )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% data - is M rows (number of points) and N column(number of features)
% k - the number of desired clusters. 
pause on;
initialPoints = randsample(size(data, 1), k);
oldCentroids = zeros(k, size(data,2));
newCentroids = data(initialPoints, :);
% if(distMetric == 3)
%     newCentroids = eucCentroids;
% end
dataPoint = zeros(k, size(data, 2));
distVec = zeros(k, 1);
newLabels = zeros(size(data, 1), 1);
oldLabels = zeros(size(data, 1), 1);

maxiter=100;
for iter =1:maxiter
    for i=1:size(data, 1)
        dataPoint = repmat(data(i, :), k, 1);
        if(distMetric == 1)
            distVec = sqrt(sum(abs(dataPoint - newCentroids).^2, 2));
        end
        if(distMetric == 2)
            distVec = sum(abs(dataPoint - newCentroids), 2);
        end
        newLabels(i) = min(find(distVec == min(distVec)));
    end
    oldCentroids = newCentroids;
    for j=1:k
        if(distMetric == 1)
            newCentroids(j, :) = mean(data(find(newLabels == j), :),1);
        end
        if(distMetric == 2)
            newCentroids(j, :) = median(data(find(newLabels == j), :),1); % for manhattan distance, the median is the centroid for a cluster
        end
    end
end

centroids = newCentroids;
classLabels = newLabels;
end

