function [ n_index ] = neighbors( curr_ind, actions )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n_index = zeros(8,2);
for i=1:length(actions)
   [n_index(i,1) n_index(i,2)] = next_state_Q5(curr_ind(1), curr_ind(2), actions{i});
end
% disp(n_index);
end

