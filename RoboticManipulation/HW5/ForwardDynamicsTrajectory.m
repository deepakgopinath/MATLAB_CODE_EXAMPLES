function [ tList, tdList ] = ForwardDynamicsTrajectory( t0, td0, torqueMat, FtipMat, Mrel, G, S, T )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

if(size(t0, 2) > 1)
    t0 = t0'; %make these into columns for computation
end

if(size(td0, 2) > 1)
    td0 = td0'; %column
end

N = size(torqueMat, 1); %number of steps. 
n = size(t0, 1); % num of joints
step = T/(N-1);
%initialize empty lists. 

tList = zeros(N, n); %arrange state at each timestep as rows.
tdList = zeros(N,n);
tddList = zeros(N,n);

%initial value for the angles and velocities
tList(1,:) = t0';
tdList(1,:) = td0';

for i=1:N-1
    tddList(i,:) = (ForwardDynamics(tList(i,:), tdList(i,:), torqueMat(i,:), FtipMat(i,:), Mrel, G, S))'; %output of forwardynamics is column. therefore transpose it
    [tList(i+1,:), tdList(i+1, :)] = EulerStep(tList(i,:), tdList(i,:), tddList(i,:), step); %row vector as input, row vector as output
end






end

