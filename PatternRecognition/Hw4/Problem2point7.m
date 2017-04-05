clear all;
clc;

N = 1000;
meanVecMatrix = [1 4 8; 1 4 1];
covMegaMatrix = zeros(2,2,3);
covMegaMatrix(:,:,1) = 2*eye(2,2);
covMegaMatrix(:,:,2) = 2*eye(2,2);
covMegaMatrix(:,:,3) = 2*eye(2,2);
priorWeightsX5 = [1/3; 1/3; 1/3];
priorWeightsX5Prime = [0.8; 0.1; 0.1];


[X5, labels] = generate_gauss_classes(meanVecMatrix, covMegaMatrix, priorWeightsX5, N);
[X5Prime, labelsPrime] = generate_gauss_classes(meanVecMatrix, covMegaMatrix, priorWeightsX5Prime, N);
zX5 = bayes_classifier(meanVecMatrix, covMegaMatrix, priorWeightsX5, X5);
confusionMatX5Bayes = confusionmat(labels, zX5);
disp('confusion matrix for X5 Bayes');
confusionMatX5Bayes
fprintf('The error computed for X5 using Bayes is %f\n', compute_error(labels, zX5));
zX5Prime = bayes_classifier(meanVecMatrix, covMegaMatrix, priorWeightsX5Prime, X5Prime);
confusionMatX5PrimeBayes = confusionmat(labelsPrime, zX5Prime);
disp('confusion matrix for X5Prime Bayes');
confusionMatX5PrimeBayes
fprintf('The error computed for X5Prime using Bayes is %f\n', compute_error(labelsPrime, zX5Prime));

zX5 = euclidean_classifier(meanVecMatrix, X5);
disp('confusion matrix for X5 Euclidean');
confusionMatrixX5Euclidean = confusionmat(labels, zX5);
confusionMatrixX5Euclidean
fprintf('The error computed for X5 using Euclidean is %f\n', compute_error(labels, zX5));

zX5Prime = euclidean_classifier(meanVecMatrix, X5Prime);
disp('confusion matrix for X5Prime Euclidean');
confusionMatrixX5PrimeEuclidean = confusionmat(labelsPrime, zX5Prime);
confusionMatrixX5PrimeEuclidean
fprintf('The error computed for X5Prime using Bayes is %f\n', compute_error(labelsPrime, zX5Prime));


