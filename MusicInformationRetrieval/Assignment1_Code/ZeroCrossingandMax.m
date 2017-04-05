%Function to determine zero crossing and the first peak after the first
%zero crossing. Return the index (with respect to) the original array X at
%which the peak occurs

%Submitted by Deepak Gopinath - 903014581

function [ maxValueIndex] = ZeroCrossingandMax(X)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

L = length(X); % assuming row vector

y1 = find(diff(X) > 0); % Compute the difference between successive elements and the see which ones are greater than 0
y2 = find(diff(X) < 0); % Compute the difference between successive elements and the see which ones are less than 0

n = 1;
while n <= length(y1)
    if(X(y1(n)) <=0 && X(y1(n)+1) > 0) %compare the values of X at the indices stored in y and check for negative to positive zero crossing
        firstIndex = y1(n)+1;
        break; 
    end  
    n = n+1;
end

n = 1;
secondIndex = L;
while n <= length(y2)
    if(X(y2(n)) >= 0 && X(y2(n)+1) < 0) %check for positive to negative zero crossing. The first one after the first one zero crossing is assigned as the secondZerocrossing
        if(y2(n) - firstIndex > 0) %To make the second one is after the first one
            secondIndex = y2(n);
            break; 
        end
    end  
    n = n+1;
end

maxValue = max(X(firstIndex : secondIndex)); %compute the max in the range of first-secondindex in X
maxValueIndex = firstIndex + find(X(firstIndex : secondIndex) == maxValue) - 1; %find the position at which the maximum occurs in this range

end

