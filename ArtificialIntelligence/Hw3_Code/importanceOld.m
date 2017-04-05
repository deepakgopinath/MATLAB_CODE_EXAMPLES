function [ sigFeature ] = importanceOld( data, k )
%  
%   function returns the attribute number with the greatest information gain.
% data - N by (d+1), where N is the number of samples, d is the number of
% attributes and the last column are the labels. 1 is positive, 
% k (scalar) = number of components in the kmeans. same k for every featureto start
% off with. 

% positive is considered to be examples with output 1
% negative is considered to be examples with output 0
d = size(data, 2) - 1;
p = length(find(data(:, d+1) == 1)); 
n = length(find(data(:, d+1) == 0));
% make sure all 0's are in the first part
mult = [-1*ones(n,1); ones(p,1)];
totalEntropy = booleanEntropy(p/(p+n));

remainderAttr = zeros(d, 1); % this will be populated by the info gain for each attribute
gainAttr = zeros(d,1);
pnForEachk = zeros(2, k, d); % first row represnts p for each k and second row is n for eack k;
for i=1:d % iterate over each attribute and compute info gain for each one and populate gainAttr matrix
    [idx, c] = kmeans(data(:,i), k); % discretizing the continuous feature into k different values using k means. Other schemes are also possible. 
    idx = idx.*mult;
    for j=1:k
        pnForEachk(1, j, i) = length(find(idx == j));
        pnForEachk(2, j, i) = length(find(idx == -j));
        pk = pnForEachk(1, j, i);
        nk = pnForEachk(2, j, i);
        remainderAttr(i) = remainderAttr(i) + ((pk + nk)/(p+n))*booleanEntropy(pk/(pk+nk));
    end
    
    %for each feature compute gain. 
end

gainAttr = totalEntropy - remainderAttr;

sigFeature = find(gainAttr == max(gainAttr));

end

