%this script randomly adds NaN at different rows for each features, thereby
%creating a missing feature data set.
d = size(data,2) - 1;
N = size(data,1);
for i=1:d
    data(randsample(N, 100), i) = NaN;
end
