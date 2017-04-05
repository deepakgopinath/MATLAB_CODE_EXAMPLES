clear all;
clc;

N = 1000;
meanVecMatrix = [1 8 13; 1 6 1];
covMegaMatrix = zeros(2,2,3);
covMegaMatrix(:,:,1) = 6*eye(2,2);
covMegaMatrix(:,:,2) = 6*eye(2,2);
covMegaMatrix(:,:,3) = 6*eye(2,2);
priorWeightsX3 = [1/3; 1/3; 1/3];

[X3, labelsX3] = generate_gauss_classes(meanVecMatrix, covMegaMatrix, priorWeightsX3, N);
[Z, labelsZ] = generate_gauss_classes(meanVecMatrix, covMegaMatrix, priorWeightsX3, N);

k = 1;
zKnn = k_nn_classifier(Z, labelsZ, k, X3);
fprintf('The confusion matrix for k = %d \n', k);
confusionmat(labelsX3, zKnn) 
fprintf('The error for knn classification with k = 1 is %f\n', compute_error(zKnn, labelsX3));

compute_error(zKnn, labelsX3)
k = 11;
zKnn = k_nn_classifier(Z, labelsZ, k, X3);
fprintf('The confusion matrix for k = %d \n', k);
confusionmat(labelsX3, zKnn) 

fprintf('The error for knn classification with k = 11 is %f\n', compute_error(zKnn, labelsX3));

