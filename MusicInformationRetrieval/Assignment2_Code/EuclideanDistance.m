function [ EuclideanDistMatrix ] = EuclideanDistance( Training, Test )

%This functions takes in two matrices as inputs. The Training Set matrix
%and Test Matrix.


% Training has p rows and D columns , where D is the number of features
% being used to characterize a point in feature space.
% Test has q rows and D columns

% output will be q by p. Each testing point in row and each column
% reprents dist to each point in training set.


n = 1;
i = 1;
trRows= size(Training, 1);
EuclideanDistMatrix = zeros(size(Test, 1), size(Training,1));
for n=1:size(Test,1) %1 :q
    tempTestMat = repmat(Test(n,:), trRows, 1);
    EuclideanDistMatrix(n,:) = sqrt(sum((Training - tempTestMat).^2, 2))';
end


end

