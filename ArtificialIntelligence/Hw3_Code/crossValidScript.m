%This script performs 10-fold cross-validation of a decision tree
clear all;clc;
data = dlmread('data_banknote_authentication.txt');
% messUpDataScript;
k = 3; % for the kmeans, the number of branches.
pathW = 0; 
N = size(data, 1); 
Ntest = floor(N/10);
d = size(data, 2);
classificationLabels = zeros(Ntest, 1);
originalLabels = zeros(Ntest, 1);
data = data(randsample(1372, 1372), :); %randomize the data
cumConfusionMatrix = zeros(2,2);
attributes = [1 2 3 4]; % needed for training a decision tree, the vector contains the attribute labels
fold = 1;
accuPreRecall = zeros(10,3);
for j=1:Ntest-1:N-Ntest+1
    tempData = data; 
    range = j:j+Ntest-1;
    testSet = tempData(range, :);
    tempData(range, :) = [];
    trainingSet = sortrows(tempData, 5); %so that the labels 0's and 1's are ordered properly
    decisionTreeLearned = decision_tree_learning(trainingSet, [1 2 3 4], trainingSet, 1, k);
    originalLabels = testSet(:, d) - 2;
    for i=1:Ntest
        [cvf, pathW] = classifyUsingTree(decisionTreeLearned, testSet(i,1:d-1),attributes, k); 
        classificationLabels(i) = cvf;
    end
    confusionMatrix = confusionmat(originalLabels,classificationLabels);
    accuracy = trace(confusionMatrix)/sum(confusionMatrix(:));
    precision = 0.5*((confusionMatrix(1,1)/sum(confusionMatrix(:,1))) + (confusionMatrix(2,2)/sum(confusionMatrix(:,2)))) ;
    recall = 0.5*((confusionMatrix(1,1)/sum(confusionMatrix(1,:))) + (confusionMatrix(2,2)/sum(confusionMatrix(2,:)))) ;
    accuPreRecall(fold, :) = [accuracy precision recall];
    fold = fold +1;
    fprintf('The accuracy, precision and recall are %f, %f, %f\n', accuracy, precision, recall);
end

