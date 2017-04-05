function [ bodyJ ] = BodyJacobian( B, theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Usage
%S - 6 by n matrix. 6 dimensions and n joints
%theta - n by 1 vector, containing all joint angles for the n joints
if(size(theta, 2) > 1)
    theta = theta';
end

bodyJ = [];
if(size(B, 1) ~= 6)
    disp('Screw axes not 6 dimensional');
elseif(size(theta, 2) > 1)
    disp('Theta is not a list of joint angles/translations');
elseif(size(B, 2) ~= length(theta))
    disp('Number of joint mismatch in S and thetqa');
else
    numJoints = size(B,2);
    bodyJ = zeros(6,numJoints);
    bodyJ(:, end) = B(:, end);
    for i=numJoints-1:-1:1
        prodT = eye(4,4);
        for j=numJoints:-1:numJoints-i+1
            prodT = prodT*MatrixExp6(-B(:,j)*theta(j));
        end
        bodyJ(:, numJoints-i) = Adjoint(prodT)*B(:, numJoints-i);
    end
    
end
end

