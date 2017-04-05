classdef Grid < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xLoc
        yLoc
        h_val
        cost
    end
    
    methods
        function obj = setLocsAndH(obj, xVal, yVal)
            obj.xLoc = xVal;
            obj.yLoc = yVal;  
        end
        function obj = setHval(obj, gX,gY)
            obj.h_val = sqrt((obj.xLoc -gX)^2 + (obj.yLoc - gY)^2);
        end
        function obj = setCost(obj, isObs)
            if isObs == 1
                obj.cost = 1000;
            else
                obj.cost = 1;
            end
        end
    end
    
end

