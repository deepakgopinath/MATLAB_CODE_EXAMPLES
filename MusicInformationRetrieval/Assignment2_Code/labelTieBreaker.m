function [ correctLabel ] = labelTieBreaker( inputVec ) 

%This function makes sure that if there are any ties in k neighbours, the
%labels for the ones which are closer to the testing point gets picked

if(size(inputVec, 2) == 1)
    inputVec = inputVec'; % The input Vector has to be a row vector
end
b = tabulate(inputVec); %tabulate the input vector
c = unique(b(:,2)); %remove redundancies from the second column, which has the frequencies
d = max(c); % find the maximum frequency
e = b(:,2) == d; % find the rows at which the maximum frequency occurs, if there are duplicates this will have more than rows
f = b(e,1); % find the values for which the max frequency happens

L = length(f);
ind = [];

for i=1:L
    
    ind = [ind find(inputVec == f(i))]; % find the index of the values for which the max frequency happens
    
end

correctLabel = inputVec(min(ind)); % find the minimum index of the values for which the max frequency happens. If the input vector was the sorted label vector, this would
% output the nearest point with the needed output label.
end

