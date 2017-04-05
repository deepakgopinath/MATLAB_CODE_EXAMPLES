function [ X ] = low_variance_resampler( X_bar, W )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

M = size(X_bar,1);
X = zeros(M, 3);
a = 0; b = 1.0/M;
r = a + (b-a)*rand();
c = W(1);
i = 1;
for m=1:M
    U = r + (m-1)*(1.0/M);
    while U > c
        i = i+1;
        if i > M
           i = 1;
        end
        c = c + W(i);
    end
    X(m,:) = X_bar(i, :); 
end
end

