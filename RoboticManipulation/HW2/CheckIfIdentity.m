function [ isidentity ] = CheckIfIdentity( X )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

dim = size(X, 1); %already assumes this is square
epsilon = 10^-5;
isidentity = true;
for i=1:dim
    if(isidentity)
        for j=1:dim
            if( i==j)
                if(abs(X(i,j) - 1) > epsilon)
                    isidentity = false;
                    break;
                end
            else
                if(abs(X(i,j) - 0) > epsilon)
                    isidentity = false;
                    break;
                end
            end
        end
    else
        break;
    end
end
end

