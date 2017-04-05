function [ gf ] = GravityForces( t, g, Mrel, G, S )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

if(size(t,2) > 1)
    t = t'; %make it into column vector;
end
n = size(t,1); %num of joints
gf = zeros(n,1);

td = zeros(n,1); 
tdd = zeros(n,1);
Ftip = zeros(6,1);

gf = InverseDynamics(t, td, tdd, g, Ftip, Mrel, G, S); %n by 1
end

