%This script ranks single features for their performance. This is step one
%of sequential forward feature selection;

f = [];
featureAccuracy = [];
for i=1:10
    f =[i];
    ret = TenFoldCrossValidation(randomizedA, f, 1, 0);
    featureAccuracy = [featureAccuracy ret];
end


[sorted, ix] = sort(featureAccuracy, 'descend');

disp('The feature numbers in descending accuracy');
rankedFeatures = ix
disp('The accuracies in percentage');
percentages = sorted*100

