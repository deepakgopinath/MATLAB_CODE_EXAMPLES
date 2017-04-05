function [ majorityLabel ] = plurality_value( data )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%majority label is -2 if label is no
% and -1 if label is yes. (these values will be used as the attribute
% values for decisiontrees with isLeaf property to be true. 

%this function returns the majority label from the given data.
numF = size(data, 2) - 1;
labelCol = data(:, numF+1);
a = tabulate(labelCol);
b = unique(a(:,2));
c = max(b);
e = a(:,2) == c;
f = a(e, 1);
if length(f) > 1
    x = randi(numel(f));
    majorityLabel = f(x) - 2;
else
    majorityLabel = f - 2;
end
end


