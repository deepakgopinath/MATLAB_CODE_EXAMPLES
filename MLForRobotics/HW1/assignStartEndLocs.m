function [ start_loc, goal_loc ] = assignStartEndLocs( index )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

switch index
    case 1
        start_loc = [0.5, -1.5];
        goal_loc = [0.5, 1.5];
    case 2
        start_loc = [4.5, 3.5];
        goal_loc = [4.5, -1.5];
    otherwise
        start_loc = [-0.5, 5.5];
        goal_loc = [1.5, -3.5];
end

end

