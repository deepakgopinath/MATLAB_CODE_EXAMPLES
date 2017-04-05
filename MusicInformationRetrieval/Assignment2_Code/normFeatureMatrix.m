%This script does the normalization for calculated features. 

% A 10-d unnormalized feature vector for 500 songs were calculated and
% stored in a text file which is getting loaded at the beginning of this
% script.

A = load('genreFeatureMatrixText.txt', '-ascii');


L = size(A,2);

lambda = [0.09 0.0269 0.626 0.6818 0.0992 0.08 0.2285 0.0375 0.4658 0.2955]; %These are the lambda for boxCox. I ended up with these values after tweaking then manually
for n=1:10
    
   X = sprintf('Normalizing feature number %d', n);
   disp(X);
   A(:,n) = boxCox(A(:,n), lambda(n)); %make the distribution into gaussian and normalize it into similar ranges
   %figure;
   %hist(A(:,n));
end

AminusTag = A;
 
labels = [ones(100,1) ; ones(100,1)*2; ones(100,1)*3 ; ones(100,1)*4; ones(100,1)*5]; %labels for each genre.

A = [A labels]; % the last column represents the class for each examples. Append label column

randomizedA = A(randperm(size(A,1)), :); %randomize the feature Matrix so that it can be used for 10 fold cross validation.

%scatter plots for a few different combinations
scatterPairs(A, 1, 7, 'spectral centroid mean', 'spectral crest factor mean');
scatterPairs(A, 9, 5, 'spectral flux mean', 'zero crossing rate mean' );
scatterPairs(A, 2, 3, 'max envelope mean', 'max envelope std' );
scatterPairs(A, 6, 8, 'zero crossing rate std','spectral crest factor std' );
scatterPairs(A, 2, 10, 'spectral centroid std', 'spectral flux std');


