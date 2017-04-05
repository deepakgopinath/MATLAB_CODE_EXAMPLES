function [ Tinv ] = TransInv( T )

%Usage:
%   Input - A Valid SE(3) transformation matrix
%   Output - Inverse transformation matrix in SE(3)

%Example:
%Input - T
%T =    0.5403   -0.8415         0    1.0000
%       0.8415    0.5403         0    2.0000
%       0         0         1.0000    3.0000
%       0         0              0    1.0000

%Output - Tinv
%       0.5403    0.8415         0   -2.2232
%       -0.8415    0.5403        0   -0.2391
%       0         0         1.0000   -3.0000
%       0         0              0    1.0000

Tinv = [];
epsilon = 10^(-5);
if (numel(size(T)) ~= 2 || size(T,1) ~= size(T,2))
    disp('T is not a valid transformation matrix either because it has more than 2 dimensions or its not square');
elseif(size(T,1) ~= 4)
    disp('T is not 4 by 4');
elseif( sum(T(4,:) == [0,0,0,1]) ~= 4)
    disp('T is not a valid transformation matrix because last row is not [0,0,0,1]')
elseif(CheckIfIdentity(T(1:3,1:3)'*T(1:3,1:3)) == false || (abs(det(T(1:3,1:3))) - 1) > epsilon)
    disp('T is not a valid transformation matrix because the R component is not SO(3)');
else
    %at this point it has been established that T is a valid transformation
    %matrix
    Tinv = zeros(4,4);
    Tinv(1:3, 1:3) = T(1:3,1:3)';
    Tinv(1:3, 4) = -T(1:3,1:3)'*T(1:3,4);
    Tinv(4, :) = [0,0,0,1];
end
end

