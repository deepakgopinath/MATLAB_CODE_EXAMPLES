function [ torqueMat ] = InverseDynamicsTrajectory( thetaList, thetadList, thetaddList, FTipList, g, Mrel, G, S) 
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%omitting validation stuff
%FtipList is N+1 by 6

N = size(thetaList, 1) - 1; 
nJ = size(thetaList, 2);    
torqueMat = zeros(N, nJ);
    
for i=1:N %for each element of the list use InverseDynamics to retreive torque for each timeInstant
    torqueMat(i, :) = InverseDynamics(thetaList(i,:), thetadList(i,:), thetaddList(i, :), g, FTipList(i,:), Mrel, G, S); %Mrel, G, S, is the same for every call, as it is always the same and relates to robot description
end


end

