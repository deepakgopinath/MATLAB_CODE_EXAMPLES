function [ out ] = data_scale( in, minval, maxval )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

in  = in  - min(in);
in = (in/range(in))*(maxval-minval);
out = in + minval;
end

