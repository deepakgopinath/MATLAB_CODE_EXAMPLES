clear all;clc;
load fisheriris;
k = 3; % for the time being
labels = [1*ones(50,1); 2*ones(50,1); 3*ones(50,1)];
figure;
scatter(meas(1:50, 1), meas(1:50, 2), 'r')
hold on
scatter(meas(51:100, 1), meas(51:100,2), 'g')
hold on
scatter(meas(101:150, 1), meas(101:150, 2), 'b')
xlabel('Sepal Length');
ylabel('Sepal Width');
title('Original dataset');

figure;

color = ['r', 'g', 'b'];

covMegaMatrix = zeros(size(meas, 2),size(meas, 2),k); % each one of the 4 by 4 matrix is for each species
CityBlockCentroids = zeros(k, size(meas, 2));
EucCentroids = zeros(k, size(meas, 2));
WeightedEuclideanCentroids = zeros(k, size(meas, 2));
disp('Euclidean distance metric');

%Part 1
[EucCentroids, kMeansLabelsEuc] = kMeansClustering(meas, k, 1, covMegaMatrix, EucCentroids);
disp('The Euclidean Class Centroids are ');
EucCentroids
for i=1:k
    scatter(meas(find(kMeansLabelsEuc == i), 1), meas(find(kMeansLabelsEuc==i),2), color(i));
    fprintf('Number of element (euclidean) in class %d', i);
    length(find(kMeansLabelsEuc == i))
    hold on;
end
xlabel('Sepal Length');
ylabel('Sepal Width');
title('kMeans Euclidean');
%Part 2
disp('City Block Metric');
figure;

[CityBlockCentroids, kMeansLabels] = kMeansClustering(meas, k, 2, covMegaMatrix, CityBlockCentroids);
CityBlockCentroids
for i=1:k
    scatter(meas(find(kMeansLabels == i), 1), meas(find(kMeansLabels==i),2), color(i));
    fprintf('Number of element (city Block) in class %d', i);
    length(find(kMeansLabels == i))
    hold on;
end
xlabel('Sepal Length');
ylabel('Sepal Width');
title('kMeans City Block');
%Part 3

disp('Rows represent species and columns represent features');

for n=1:k
    covMegaMatrix(:,:,n) = cov(meas(find(kMeansLabelsEuc == n),:));
end

disp('The means/centroids are ');
EucCentroids
disp('The covariance matrix is ');
covMegaMatrix

% in general weighted euclidean is (x - mu)'*Q*(x - mu), where Q is the
% weight and mu is the centroid
% in our case Q is chosen as the inverse of the covariance matrices and mu
% refer to the centroid

% weightedDist = zeros(k, 1);
% kMeansLabelsMinDist = zeros(size(meas, 1), 1);
% for i=1:size(meas, 1)
%     diffXandMean = repmat(meas(i, :), k, 1) - EucCentroids; % row vectors
%     for j=1:k
%         weightedDist(j) = sqrt(diffXandMean(j, :)*inv(covMegaMatrix(:,:,j))*diffXandMean(j, :)');
%     end
%     kMeansLabelsMinDist(i) = min(find(weightedDist == min(weightedDist)));
% end
% 
% figure;
% disp('Minimum distance weighted euclidean');
% for i=1:k
%     scatter(meas(find(kMeansLabelsMinDist == i), 1), meas(find(kMeansLabelsMinDist == i),2), color(i));
%     hold on;
% end

%Part 3b kMeans with weighted Euclidean distance. 

disp('kMean weighted euclidean');
figure;

[WeightedEuclideanCentroids, kMeansLabelsWeightedEuclidean] = kMeanClusteringWeighted(meas, k, covMegaMatrix, EucCentroids);
WeightedEuclideanCentroids
for i=1:k
    scatter(meas(find(kMeansLabelsWeightedEuclidean == i), 1), meas(find(kMeansLabelsWeightedEuclidean==i),2), color(i));
    fprintf('Number of element (Weighted Euclidean) in class %d', i);
    length(find(kMeansLabelsWeightedEuclidean == i))
    hold on;
end
xlabel('Sepal Length');
ylabel('Sepal Width');
title('kMeans Weighted Euclidean');