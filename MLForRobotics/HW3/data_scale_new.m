function [ out ] = data_scale_new( in, minin, maxin, minval, maxval)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

in  = in  - minin;
in = (in/(maxin - minin))*(maxval-minval);
out = in + minval;
end

