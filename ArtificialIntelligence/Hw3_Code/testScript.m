clear all; clc;
data = dlmread('data_banknote_authentication.txt');

%762 0's
%610 1's

% f = size(data, 2) - 1; % number of features
% N = size(data, 1);
% d = 4;
% discreteInfo = zeros(2, d, f); %min and max for each of the d levels encoded as a 2 by d matrix for each of the f features
% %discretize the f continuous features into d discrete levels each (for the
% %time being the number of discrete levels for each feature is the same)
% for i=1:f
%     minFi = min(data(:,i));
%     maxFi = max(data(:,i));
%     rangeFi = maxFi - minFi;
%     incr = rangeFi/d;
%     lowVal = minFi;
%     for j=1:d
%         highVal = lowVal + incr;
%         discreteInfo(1,j,i) = lowVal;
%         discreteInfo(2,j,i) =  highVal;
%         lowVal = highVal;
%     end
% end 

