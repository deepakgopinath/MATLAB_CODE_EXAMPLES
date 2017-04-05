function [ out ] = feed_forward(in, w_cells, b_cells, num_layers)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

   out = in;
   for i=1:num_layers-1
    out = sigmoid(w_cells{i}*out + b_cells{i});
   end
end

function sigz = sigmoid(z)
    sigz = 1.0./(1.0 +  exp(-z));
end
