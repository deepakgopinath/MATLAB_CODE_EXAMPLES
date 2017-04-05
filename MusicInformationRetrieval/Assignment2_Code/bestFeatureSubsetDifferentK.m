function [ output_args ] = bestFeatureSubsetDifferentK( bestF )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

disp('For k = 1');
a = TenFoldCrossValidation(randomizedA, bestF, 1, 1);
a

disp('For k = 3');
a = TenFoldCrossValidation(randomizedA, bestF, 3, 1);
a


disp('For k = 5');
a = TenFoldCrossValidation(randomizedA, bestF, 5, 1);
a
end

