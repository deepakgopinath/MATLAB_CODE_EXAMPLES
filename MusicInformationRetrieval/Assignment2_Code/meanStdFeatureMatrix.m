function [ featureVector ] = meanStdFeatureMatrix(featureMatrix)

%this function takes the feature matrix for each audiofile and calculates
%the mean and std deviation for each feature calculated and returns a 10
%dimensional vector each audio file.

meanVec = mean(featureMatrix, 2); %5 rows one column
stdVec = std(featureMatrix, 0, 2);%5 rows one column

stackMatrix = [meanVec'; stdVec']; %stack the transposed column vectors on top of each other

featureVector = reshape(stackMatrix, 1 , []); %row vector, interlace the two rows of stackMatrix

end

