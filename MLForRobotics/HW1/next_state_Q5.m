function [ next_row,  next_col ] = next_state_Q3( curr_row, curr_col, action )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

deltaY = action(1); %change in x direction = change in column number
deltaX = action(2); %change in y direction = change in row number

next_row = max(curr_row + deltaY);
if next_row < 1
    next_row = 1;
end
if next_row > 120
    next_row = 120;
end
next_col = curr_col + deltaX;
if next_col < 1
    next_col = 1;
end
if next_col > 70
    next_col = 70;
end
end



