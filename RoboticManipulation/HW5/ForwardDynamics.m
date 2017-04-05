function [ tdd ] = ForwardDynamics(t, td, torque, Ftip,Mrel, G, S)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

if(size(torque, 2) > 1)
    torque = torque';
end
g = [0;0;-9.81];

%Compute each component of right hand side
cf = CoriolisForces(t, td, Mrel, G, S);
gf = GravityForces(t,g,Mrel,G,S);
eef = EndEffectorForces(t, Ftip, Mrel, G, S);
mm = InertiaMatrix(t, Mrel, G, S);

rhs = torque - cf - gf - eef; %n by 1

tdd = mm\rhs; % Solve for M*thetadd = rhs as column vector
end

