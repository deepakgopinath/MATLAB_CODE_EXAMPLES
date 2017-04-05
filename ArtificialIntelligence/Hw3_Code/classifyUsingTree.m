function [ classificationResult, pathWeight] = classifyUsingTree(tree, testInstance, attributes, k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%attributes is a vector containing the features and the order too. It can
%be something like [4 2 3 1].
% actual Labels is a list of 0 and 1 . used for calculating confusion
% matrix

%tree - is the learned decision tree from DTL algo.
% N = size(testInstance, 1); % number of test samples;
% d = size(testInstance, 2); % number of features in the testSet. 

classificationResult = -1;
pathWeight = 1.0;
weightOptions = ones(k,1);
classificationVec = -1*ones(k,1);

if(sum(unique(tree.attributeName == attributes)) == 1 && isnan(testInstance(tree.attributeName)) == 0) % the sample being tested has the feature that will be tested at this node and has a valid value(not missing).  
  eucDistTestPointSplitPoint = (tree.splitPoints-repmat(testInstance(tree.attributeName), k, 1)).^2; %find closest centroid. or the discrete level and this determines the branch to take.
  branch = find(eucDistTestPointSplitPoint == min(eucDistTestPointSplitPoint));
  if(numel(branch) > 1) % this if statement is here to deal with those nodes (usually leaf), whose centroids and weights are just default values and therefore 'branch' will become multidimensional
    branch = branch(randi(numel(branch))); % just pick one of them randomly.
  end
  temp = tree.nodes(branch); %temp is also a tree. temp is the node present on the chose branch
  pathWeight = tree.weightsForEachBranch(branch); % keep track of weight along that path
  res = temp.isLeaf == false; %check whether the node picked is a leaf node or not. If not continue recursion along the path.
  if(res == 1)   
    tempAttr = attributes; 
    tempAttr(attributes == tree.attributeName) = []; %remove already tested attribute 
    [classificationResult, pWeight] = classifyUsingTree(temp, testInstance, tempAttr, k);
    pathWeight = pathWeight*pWeight; %the weights from the bottom branches are multiplied
  else
    classificationResult = temp.attributeName; % because -2 is 0 and -1 is 1. So add +2 to the attribute name to get the correct label value.
  end
elseif(sum(unique(tree.attributeName == attributes)) == 1 && isnan(testInstance(tree.attributeName)) == 1)
   % the attribute is present but missing value;
   % try going along all paths
   for iter=1:k
      branch = iter;
      tempBranch = tree.nodes(branch); %temp is also a tree 
      weightOptions(iter) = tree.weightsForEachBranch(branch);
      if(tempBranch.isLeaf == false)
        %remove already the tested attribute;
        tempAttr = attributes;
        tempAttr(attributes == tempBranch.attributeName) = []; 
        [cvfg, pWeight] = classifyUsingTree(tempBranch, testInstance, tempAttr, k);
        classificationVec(iter) = cvfg;
        weightOptions(iter) = weightOptions(iter) * pWeight;
      else
        classificationVec(iter) = tempBranch.attributeName; % because -2 is 0 and -1 is 1. So add +2 to the attribute name to get the correct label value.
     end
   end
   classificationResult = classificationVec(min(find(weightOptions == max(weightOptions))));  
   pathWeight = max(weightOptions);
end

end

