function [ bcVector ] = boxCox( inputVec, lambda )

%performs the boxcox transform on an inputVec

bcVector = (inputVec.^lambda - 1)/lambda;
mBc = mean(bcVector);
stdBC = std(bcVector);

bcVector = (bcVector - mBc)/stdBC;
end

