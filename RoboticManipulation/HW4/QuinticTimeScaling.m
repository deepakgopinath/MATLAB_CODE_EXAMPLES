function [s_t] = QuinticTimeScaling( T, t)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% t can be vector of time values, a matrix or a scalar
if(size(t, 2) > 1)
    t = t';
end
s_t = [];
if (sum(t > T) > 0 || sum(t < 0) > 0)
    disp('the values of t has to be 0 <= t <= T');
else
    s_t = (10/(T^3))*(t.^3) + (-15/(T^4))*(t.^4) + (6/(T^5))*(t.^5);
end
end

