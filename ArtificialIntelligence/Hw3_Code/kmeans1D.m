function [labels, means] = kmeans1D(data,  k )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

%data = N by 1;
%means = k by 1

N = size(data, 1);
epsilon = 0.01;
while true
    x = 1;
    initialMeansIdx = randsample(size(data, 1), k);
    means = data(initialMeansIdx);  
    if (length(unique(means)) ~= length(means))
        continue;
    else
        break;
    end
end

oldmeans = zeros(k,1);
max_iter = 5000;
labels = zeros(size(data,1), 1);
for i=1:max_iter
    
    dataNbyk = repmat(data, 1, k);
    meansNbyk = repmat(means', N, 1);
    distNbyk = abs(dataNbyk - meansNbyk); % distance in 1d is city block
    [x, labels] = min(distNbyk, [], 2);
    for j=1:k
        means(j) = mean(data(labels ==j));
    end
    if(mean(abs(means-oldmeans)) < epsilon)
%         fprintf('The iter number is %d \n', i);
        break
    else
        oldmeans = means;
    end
end

distNbyk
end

