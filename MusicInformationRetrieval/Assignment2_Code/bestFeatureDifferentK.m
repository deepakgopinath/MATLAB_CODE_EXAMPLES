%This script requires the user to look at the results of "sequentialFSel"
%and select which feature combination has the maximum accuracy and make that
%feature combination bestF. This script then uses that feature combination
%and performs ten fold validation for k=1 3 5 and generates confusion
%matrices for each iteration of the validation. 

% bestF = [3  8  9  7  10 5  6  1  4 2];

disp('For k = 1');
[accuracy, cumulativeConfusionMatrix] = TenFoldCrossValidation(randomizedA, bestF, 1, 1);
accuracy
cumulativeConfusionMatrix

disp('For k = 3');
[accuracy, cumulativeConfusionMatrix] = TenFoldCrossValidation(randomizedA, bestF, 3, 1);
accuracy
cumulativeConfusionMatrix

disp('For k = 7');
[accuracy, cumulativeConfusionMatrix] = TenFoldCrossValidation(randomizedA, bestF, 7, 1);
accuracy
cumulativeConfusionMatrix  