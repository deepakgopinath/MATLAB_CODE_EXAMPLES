function [ accuracyAve, cumulativeConfusionMatrix ] = TenFoldCrossValidation( TotalSet, FeatureSubSetIndexVector, k, isConfusionOutput  )


%Number of rows in the TotalSet represent the total number of samples
%available. Split them into 10 groups and use 1/10th as test set and the
%remaining as training set. slide the test set from one end to the other. 
%For each featureSubset do this to obtain the accuracy of that
%featureSubset. 

%if the FeatureSubsetIndexVector is [ 4 2 6 1]. it means use the 4th, 2nd,
%6th and 1st features (or column from the featureMatrix0 consolidate them
%into one new matrix and then pass it to the knnClassifier. 

noOfDataPoints = size(TotalSet, 1);
testSetSize = noOfDataPoints/10;

accuracyAccum = 0;

n = 1;
index = 1;
AMatrix = [];
cumulativeConfusionMatrix = zeros(5,5);

while n <= noOfDataPoints - testSetSize + 1

    AMatrix = TotalSet; %Make a copy so that the original matrix stays in tact during iterations
    range = n:n+testSetSize-1;
    TestSetRows = AMatrix(range, :);
    AMatrix(range, :) = []; %A - TestSet = TrainingSet;
    
    trSet = AMatrix(:, FeatureSubSetIndexVector); %This doesnt include the label, which is the last column;
    teSet = TestSetRows(:, FeatureSubSetIndexVector);
    trSetLabel = AMatrix(:, 11);
    teSetLabel = TestSetRows(:, 11);
%     st = sprintf('the confusion matrix for iteration %d', index);
%     disp(st);
    [returnVal, confusionMatrix] = knnClassifier(k, trSet, trSetLabel, teSet, teSetLabel,isConfusionOutput);
    
    cumulativeConfusionMatrix = cumulativeConfusionMatrix + confusionMatrix;
    %disp(n);
    n = n + testSetSize;
    accuracyAccum = accuracyAccum + returnVal;
    AMatrix = [];
    index = index +1 ;
    
end
accuracyAve = accuracyAccum/10;

cumulativeConfusionMatrix = cumulativeConfusionMatrix ./10;
end

