function [ mm ] = InertiaMatrix(t, Mrel, G, S )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

if(size(t,2) > 1)
    t = t'; %make it into column vector;
end
n = size(t,1); %num of joints
mm = zeros(n,n); % initialize mass matrix with zero. 

td = zeros(n,1); % joint velocities always is zero. 
Ftip = zeros(6,1); % external force to be zero. 
g = zeros(3,1); %gravity to be set as zero. 

for i=1:n
    tdd = zeros(n,1); tdd(i) = 1; %cycle through different joints and make joint accelerations = 1. 
    %[1,0,0,0,0,0], [0,1,0,0,0,0], [0,0,1,0,0,0], [0,0,0,1,0,0,0]
    mm(:,i) = InverseDynamics(t, td, tdd, g, Ftip, Mrel, G, S);
end

end

