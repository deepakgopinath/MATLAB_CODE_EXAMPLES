classdef constantDecisionTree < decisionTree
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value;
    end
    
    methods
        function cdt = constantDecisionTree(val)
            cdt = cdt@decisionTree();
            cdt.value = val;
        end
    end
    
end

