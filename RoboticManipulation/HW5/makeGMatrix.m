function [G ] = makeGMatrix( m, Ixx, Ixy, Ixz, Iyy, Iyz, Izz)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%utility function to make inertia tensor
G = zeros(6,6);
G(1:3,1:3) = [Ixx, Ixy, Ixz;
              Ixy, Iyy, Iyz;
              Ixz, Iyz, Izz];
G(4:6,4:6) = m*eye(3);
end

