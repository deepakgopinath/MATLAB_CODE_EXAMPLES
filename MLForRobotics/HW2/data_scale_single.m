function [ out] = data_scale_single(in, in_min, in_max, minval, maxval)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

in  = in  - in_min;
in = (in/(in_max - in_min))*(maxval-minval);
out = in + minval;

end

