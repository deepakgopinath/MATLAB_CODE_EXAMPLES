function [ curr_ind ] = getindices(xValues, yValues, curr_loc)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
% 
% curr_ind = [0 0];
% curr_loc = round(curr_loc, 3);
% for i=1:size(grids,1)
%     for j=1:size(grids,2)
%         if abs(grids{i,j}.xLoc  - curr_loc(1)) <= 0.05 && abs(grids{i,j}.yLoc - curr_loc(2)) <= 0.05
%             curr_ind = [i j];
%         end% 
%     end
% end
% end

curr_ind = [0,0];
n = abs(yValues - curr_loc(2));
m = min(abs(yValues - curr_loc(2)));
curr_ind(1) = length(yValues) - find(n == m) + 1;

n = abs(xValues - curr_loc(1));
m = min(abs(xValues - curr_loc(1)));
curr_ind(2) = find(n == m);

end

