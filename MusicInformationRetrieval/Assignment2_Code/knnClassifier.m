%prior to calling this function the featureMatrix should be appended with
%one more column containing the labels for each class.. And this happens in
%normFeatureMatrix script. 

function [ Accuracy, confusionMatrix ] = knnClassifier( k, TrainingSet, TrainingLabelSet, TestSet, TestLabelSet, isConfusionOutput ) %Both training and test set should have the same number of columns which will be the number of features used to represent each sample

%TrainingLabelSet is a p by 1
%TestlabelSet is passed in for checking the results and creating the
%confusion matrix. 
%TestLabelSet is q by 1; column vector, containing all the labels.


dimensionality = size(TrainingSet, 2);
testSetSize = size(TestSet, 1);
classSet = unique(TrainingLabelSet); %this is a column vector; [ 1 2 3 4 5]'

%Let the number of training samples be p and number of testing samples be
%q

%Then TrainingSet = p by D
%TestSet = q by D
%TraininglabelSet = q by 1


%We have to find the euclidean distance between each point in the testSet
%and all the other points in the training set. for each q points in TestSet
%we will have a p dimensional vector (with each element being the distance
%to the p training set examples. if we sort this p dim vector in increasing
%order for each of the q test set points and pick the first k elements from
%the and get the class labels for the k elements and see which class has
%the max hits. that will be the output class label for that test set point.
%

EuclideanDistMatrix = EuclideanDistance(TrainingSet, TestSet); %q by p dimension. 

%now we have to sort each row. 

[SortedEuclideanDistMatrix, indexMatrix] = sort(EuclideanDistMatrix,2);

% now we have to take the first k columns of the indexMatrix, this has the
% This has the current row number for the training set's last column which
% contains all the labels. 

kColumnsIndexMatrix = indexMatrix(:, 1:k); % First k columns, correspond to the k closest points to the test set. this is a q by k matrix
LabelsCorrespondingTokColsOfIndexMatrix = TrainingLabelSet(kColumnsIndexMatrix); % get the labels of the k closest points to the point sin the test set

%This is an ordered vector. that is the lowest numbered elements are more
%closer to the testing point. 

%mode is the simplest, but will not take into account multiplicities in
%maxima
%mostFrequentClassLabel = mode(LabelsCorrespondingTokColsOfIndexMatrix, 2); % retrieve the most frequent value for each row. this is a q by 1 vector
% mode is much faster than implementing the custom tiebreaker method. But
% mode would not ensure proper solution of
mostFrequentClassLabel = [];
for i=1:size(TestSet,1)
    mostFrequentClassLabel = [mostFrequentClassLabel; labelTieBreaker(LabelsCorrespondingTokColsOfIndexMatrix(i, :))]; %retreive the most frequent value for each row. accounts for tie breaker. in case of tie breaker go for the point which is nearest
end

%Construct confusion matrix
confusionMatrix = zeros(size(classSet,1));

for i=1:testSetSize
    
    confusionMatrix(TestLabelSet(i), mostFrequentClassLabel(i)) = confusionMatrix(TestLabelSet(i), mostFrequentClassLabel(i)) + 1; %position i,j refers to truelabel, predicted label

end

if(isConfusionOutput == 1)
confusionMatrix = (confusionMatrix ./ (repmat(sum(confusionMatrix,2), 1, size(confusionMatrix,2))))*100; % if output requested, print the output
end

% at this stage

CompareVector = mostFrequentClassLabel == TestLabelSet; % column vector comparision, CompareVector is also a column
Accuracy = sum(CompareVector)/ size(CompareVector,1);
%disp(Accuracy);
end

