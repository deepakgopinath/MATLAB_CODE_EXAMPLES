function [ X ] = low_variance_resampler_udacity( X_bar, W)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%W - can be normalized weights or not. 


x_min = 0.5940041;
x_max = 4.6103;
y_min = -3.0843;
y_max = 3.3232;
theta_min = -3.1414;
theta_max = 3.1415;
M = size(X_bar,1);
X = zeros(M, 3);
index = randi(M); 
beta = 0.0;
maxw = max(W); 
for i=1:M
    r = rand();
    if r < 0.98
        beta = beta + rand()*2*maxw;
        while beta > W(index)
            beta = beta - W(index);
            index = index + 1;
            if index > M
                index = 1;
            end
        end
        X(i, :) = X_bar(index, :);
    elseif r < 0.99
        randind = randi(M);
        X(i,:) = X_bar(randind,:);
    else
        X(i,:) = [(x_max - x_min).*rand(1,1) + x_min, (y_max-y_min).*rand(1,1) + y_min, (theta_max-theta_min).*rand(1,1) + theta_min];
    end
end


end

