function [ s_t ] = CubicTimeScaling(T, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%T is the total time
% t is the current time

% t can be vector of time values, a matrix or a scalar
if(size(t, 2) > 1)
    t = t';
end
s_t = [];
if (sum(t > T) > 0 || sum(t < 0) > 0)
    disp('the values of t has to be 0 <= t <= T');
else
    s_t = (3/(T^2))*(t.^2) + (-2/(T^3))*(t.^3);
end
end

