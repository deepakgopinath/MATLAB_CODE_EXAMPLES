% function [ tree ] = decision_tree_learning( examples, attributes, parent_examples, depth)
% %UNTITLED7 Summary of this function goes here
% %   Detailed explanation goes here
% %examples is N by d matrix
% % attributes is d dimensional vector, containing the columns that we are
% % interested in. If the entire attribute set is A1 A2 A3 A4, then
% % attributes can be [1 3 4] which means ignore attribute 2. 
% 
% d = size(examples, 2) - 1;
% n = size(examples,1);
% k = 3;
% if(n == 0) % if the number of examples is 0;
%     tree = constantDecisionTree(plurality_value(parent_examples));
% elseif (allExampleSameClassificationCheck(examples) == true)
%     tree = constantDecisionTree(examples(1, d+1)); % since all labels are same, pick the label of the first example
% elseif (isempty(attributes) == true) % if attributes are empty
%     tree = constantDecisionTree(plurality_value(examples));
% else
%     [importantAttr, idxImportantAttr] = importance(examples, attributes, k); % second argument is for the discretization of the continuous variable space using kmeans
%     
%     tree = decisionTree(importantAttr); % make a tree with rootnode as importantAttr (The argument is the column number for the attribute)
%     for i=1:k % there are k possible values for each feature.
%         relIdx = idxImportantAttr == i;
%         relExamples = examples(relIdx, :); % examples whose Ath attribute has value i
%         tempAttr = attributes;
%         tempAttr(find(attributes == importantAttr)) = [];
%         fprintf('The most important feature is %d\n', importantAttr);
%         fprintf('The current depth level is %d\n', depth);
%        
%         subtree = decision_tree_learning(relExamples, tempAttr, examples, depth+1);
%         fprintf('The kth  value for level %d the most important attribute for this level is %d\n',depth, i);
%         tree
%         subtree
%         tree.addNode(subtree, i);
%     end
% end
% end
% 


function [tree] = decision_tree_learning(examples, attributes, parent_examples, depth,k)

%examples - N by p matrix. where p is the total number of attributes in the
%beginning 
% attributes is d dimensional vector, containing the columns that we are
% interested in. If the entire attribute set is A1 A2 A3 A4, then
% attributes can be [1 3 4] which means ignore attribute 2. 

d = size(examples, 2) - 1;
N = size(examples, 1);

if(N <= k) %less than k, or else k means will fail. 
   tree = decisionTree(plurality_value(parent_examples),true, zeros(k,1), ones(k,1)); % on leaf nodes the centroids dont matter. 
elseif(allExampleSameClassificationCheck(examples) == true)
   tree = decisionTree(examples(1, d+1) - 2, true, zeros(k,1), ones(k,1));% grab the label from one of the examples (all the examples have same label) and subtract 2 so that NO becomes -2 and YES becomes -1 as this is a leaf node.
elseif(isempty(attributes) == true)
   tree = decisionTree(plurality_value(examples), true, zeros(k,1), ones(k,1));
else
   [importantAttr, idxImportantAttr, cImportantAttr, wImportantAttr] = importanceModified(examples, attributes, k);
    %the split points are needed at each node so that during classification
    %appropriate branch can be picked based on what discrete level does the
    %attribute value of the testing sample lies. 
   tree = decisionTree(importantAttr, false, cImportantAttr, wImportantAttr); %for that depth find the most important feature and create a node that is not a leaf node 
   for i=1:k %there are k different values for importantfeature
    relIdx = idxImportantAttr == i; % get the index of all the examples whose importantAttr has value i
    relEx = examples(relIdx, :);
    tempAttr = attributes;
    tempAttr(find(attributes == importantAttr)) = []; % remove the importantAttr from the attributevector
    subtree = decision_tree_learning(relEx, tempAttr, examples, depth+1, k);
    tree.addNode(subtree, i); % add the subtree at the ith branch of this node.
   end
end
end
