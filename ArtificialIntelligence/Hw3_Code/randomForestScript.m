% this script creates a trains a randomforest with numOfTrees number of
% decision trees and tests it using 10 fold cross validation
clear all; clc;
numOfTrees = 300;
decisionTreeArray = decisionTree.empty; %to keep track of the learned decision trees
data = dlmread('data_banknote_authentication.txt');
% messUpDataScript; % this is when we want to add missing features
k = 4; % number of branches per node, also the argument for kmeans discretization
fold = 1;
totalNumSamples = size(data,1);
totalNumFeatures = size(data,2) - 1;
accuPreRecall = zeros(10,3); %matrix to store the accuracy, precision and recall of each fold
numOfTestSamples = floor(totalNumSamples/10);
numOfTrainingSamples = totalNumSamples - numOfTestSamples;
data = data(randsample(totalNumSamples, totalNumSamples), :); %jumble the data rows
classificationLabelsMatrix = zeros(numOfTestSamples, numOfTrees);
classificationLabelsVector = zeros(numOfTestSamples,1);
originalLabels = zeros(numOfTestSamples, 1);
featuresForEachTree = zeros(numOfTrees, totalNumFeatures);
for j=1:numOfTestSamples-1:totalNumSamples-numOfTestSamples+1
    tempData = data;
    range = j:j+numOfTestSamples-1;
    testSet = tempData(range, :); %extract the testSet
    tempData(range, :) = []; %remove test Set
    trainingSet = sortrows(tempData, 5); %take the remaining (training set )and sort it according to labels so that later on in dtl the labels are multiplied properly to capture whether they are negative or positive
    featuresForEachTree = zeros(numOfTrees, totalNumFeatures); %for each decision tree learned, the set of features used are different. keep track of that as it is needed during testing
    originalLabels = testSet(:, totalNumFeatures+1) - 2;
    
    %learning k decision tress for a random forest
    for iterNum=1:numOfTrees % learning numOfTrees number of trees
        smalln = randi(numOfTrainingSamples); % sample n from the dataset
        t = randi(totalNumFeatures);% sample m number of features
        tempTrainingData = trainingSet;
        attributeVector = sort(randsample(totalNumFeatures, t));
        %keep track of what features to test for each tree.
        tempZ = find(featuresForEachTree(iterNum, :) == 0);
        [tempN, tempM] = ismember(attributeVector, tempZ);
        tempZ(tempM) = 1;
        tempZ(setdiff(tempZ, tempM)) = 0;
        featuresForEachTree(iterNum,:) = tempZ;
        
        tempTrainingData = tempTrainingData(randsample(numOfTrainingSamples,smalln), [attributeVector;totalNumFeatures+1]);
        tempTrainingData = sortrows(tempTrainingData, size(tempTrainingData, 2));
        decisionTreeArray(iterNum) = decision_tree_learning(tempTrainingData, 1:t,tempTrainingData, 1, k);
    end
    
    %testing phase. 
    for i=1:numOfTestSamples
        for iterNum=1:numOfTrees
            tempInd = find(featuresForEachTree(iterNum, :) == 1);
            tempTest = testSet(i, tempInd);
            [classificationLabelsMatrix(i,iterNum), pathW] = classifyUsingTree(decisionTreeArray(iterNum),tempTest,1:length(tempInd),k); 
        end
        classificationLabelsVector(i) = mode(classificationLabelsMatrix(i, :)); % get the majority vote from all the labels from all the decision trees learned
    end
    confusionMatrix = confusionmat(originalLabels,classificationLabelsVector);
    accuracy = trace(confusionMatrix)/sum(confusionMatrix(:));
    precision = 0.5*((confusionMatrix(1,1)/sum(confusionMatrix(:,1))) + (confusionMatrix(2,2)/sum(confusionMatrix(:,2)))) ; %average for both classes
    recall = 0.5*((confusionMatrix(1,1)/sum(confusionMatrix(1,:))) + (confusionMatrix(2,2)/sum(confusionMatrix(2,:)))) ; %average for both classes
    accuPreRecall(fold, :) = [accuracy precision recall];
    fold = fold + 1;
    fprintf('The accuracy, precision and recall are %f, %f, %f\n', accuracy, precision, recall);
end
