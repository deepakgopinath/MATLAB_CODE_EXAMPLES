function [ R ] = MatrixExp3( r )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%Usage 
% Input - Exponential coordinates r = omega*theta
% Output - R, the rotation matrix SO(3) representing the same rotation

%Example, from the text (Example 3.1, Page 64)
% Input - [0, 0.4538, 0.2620]'
% Output -  0.8658   -0.2502    0.4333
%           0.2502    0.9665    0.0581
%           -0.4333    0.0581    0.8994

R = [];
if(size(r,2) > 1) %Make it a column vector if a row vector
    r = r';
end

if(size(r,2) > 1) % if a matrix
    disp('r is not a vector');
elseif(size(r, 1) ~= 3)
    disp('r is not a 3d vector');
elseif(sum(r == zeros(3,1)) == 3)
    R = eye(3);
else
    w = r/norm(r); %create unit vector
    theta = norm(r); % extract theta
    ssMatrix = VecToso3(w); % make skew symmetric matrix
    R = eye(3) + sin(theta)*(ssMatrix) + (1 - cos(theta))*(ssMatrix^2); % use rodriguez formula
end

end

