function [ covarianceMatrix ] = covariance( featureMatrix )  %takes in a P by D matrix where P is the number of samples and D is the dimensionality.

%This function calculates the covariance matrix for the feature matrix
%The output is a matrix of dimension D by D

meanFeatures = mean(featureMatrix);

repMeanFeatures = repmat(meanFeatures, size(featureMatrix, 1), 1); %make the meanFeatures vector into a matrix so that the mean can be subtracted from all elements of the feature Matrix easily

differenceMatrix = featureMatrix - repMeanFeatures;

covarianceMatrix = differenceMatrix'*differenceMatrix; %matrix multiplication of transpose and non-transposed will yield all the necessary product combination so of columns

covarianceMatrix = covarianceMatrix/(size(featureMatrix, 1) - 1)

end

