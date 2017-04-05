function [ eef ] = EndEffectorForces(t, Ftip, Mrel, G, S )
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

if(size(t,2) > 1)
    t = t'; %make it into column vector;
end
n = size(t,1); %num of joints
eef = zeros(n,1);

td = zeros(n,1);
tdd = zeros(n,1);
g = zeros(3,1);

eef = InverseDynamics(t,td,tdd,g,Ftip,Mrel, G, S);
end

