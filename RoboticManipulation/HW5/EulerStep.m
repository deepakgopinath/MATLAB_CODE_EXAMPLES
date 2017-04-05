function [ tAft, tdAft ] = EulerStep( t, td, tdd, step )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

%Skipping all kinds of validation check on input. Assuming expert user
%use
tAft = t + step*td;
tdAft = td + step*tdd;

end

