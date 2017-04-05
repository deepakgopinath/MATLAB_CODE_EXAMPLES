function [ sigFeature, idxFeature, cFeature] = importance( data, attributeVec, k )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

numAttributes = length(attributeVec);
d = size(data, 2) - 1;
p = length(find(data(:, d+1) == 1)); 
n = length(find(data(:, d+1) == 0));
mult = [-1*ones(n,1); ones(p,1)]; %assumes that all the 0 labels are at the top of data list and all the 1's are the latter 'half'
totalEntropy = booleanEntropy(p/(p+n));
% k = min(k,size(data,1));
remainderAttr = zeros(numAttributes, 1); % this will be populated by the info gain for each attribute
gainAttr = zeros(numAttributes,1);
pnForEachk = zeros(2, k, numAttributes); % first row represnts p for each k and second row is n for eack k;
idxI = zeros(n+p, numAttributes);
cI = zeros(k, numAttributes);
for i=1:numAttributes
    [idx, c] = kmeans(data(:, attributeVec(i)), k, 'EmptyAction', 'singleton');
    idxI(:,i) = idx;
    cI(:,i) = c;
    idx = idx.*mult;
    for j=1:k
        pnForEachk(1, j, i) = length(find(idx == j));
        pnForEachk(2, j, i) = length(find(idx == -j));
        pk = pnForEachk(1, j, i);
        nk = pnForEachk(2, j, i);
        remainderAttr(i) = remainderAttr(i) + ((pk + nk)/(p+n))*booleanEntropy(pk/(pk+nk));
    end
end
gainAttr = totalEntropy - remainderAttr;
sigFeature = attributeVec(min(find(gainAttr == max(gainAttr))));
idxFeature = idxI(:,min(find(gainAttr == max(gainAttr))));
cFeature = cI(:, min(find(gainAttr == max(gainAttr))));
end

