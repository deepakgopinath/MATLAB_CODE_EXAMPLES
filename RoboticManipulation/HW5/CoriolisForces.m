function [ cf ] = CoriolisForces( t, td, Mrel, G, S)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
if(size(t,2) > 1)
    t = t'; %make it into column vector;
end
n = size(t,1); %num of joints
cf = zeros(n,1); %just a column vector

tdd = zeros(n,1);
g = zeros(3,1);
Ftip = zeros(6,1);

cf = InverseDynamics(t,td,tdd,g,Ftip,Mrel,G,S);

end

