function [ start_loc, goal_loc ] = assignStartEndLocs_Q3( index )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

switch index
    case 1
        start_loc = [2.45, -3.55];
        goal_loc = [0.95, -1.55];
    case 2
        start_loc = [4.95, -0.05];
        goal_loc = [2.45, 0.25];
    otherwise
        start_loc = [-0.55, 1.45];
        goal_loc = [1.95, 3.95];
end

end

