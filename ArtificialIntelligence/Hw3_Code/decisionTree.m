classdef decisionTree < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    %class which represents a node in decision tree, along with the
    %branches and the children
    properties
        attributeName; %the attribute being tested at the node. In case of leaf node it will be label
        nodes; %array to keep track of children. children are of type decisionTree
        isLeaf; %flag to keep track of leaf or not leaf
        splitPoints; %to store the discretization part. 
        weightsForEachBranch; % to store weights for missing feature classifcation
    end
    
    methods
        function dt = decisionTree(attrName, isL, centroids, weights) %the decision while classification will happen if the node is only a leaf node. 
            dt.attributeName = attrName;
            dt.isLeaf = isL;
            dt.nodes = decisionTree.empty;
            dt.splitPoints = centroids;
            dt.weightsForEachBranch = weights;
        end
        function addNode(dt, newDt, index)
            dt.nodes(index) = newDt; %index referes to the discretization levels. There are only k possible level.
        end
    end
    
end

