function [torques] = InverseDynamics(theta, thetad, thetadd, g, Ftip, Mrel, G, S)

%Computes joint torques to produce a required theta, thetad, thetadd, g
%FTip, and robot description

%Input - theta - joint angle n by 1
%          thetad - joint velocity n by 1
%          thetadd - joint accel n by 1
%          g - gravitational accel, 3 by 1
%          Ftip - Spatial wrench of the end effector, 6 by 1
%          Mrel - SE(3) of all joints wrt previous joints when joint angles are 0. 
%          G -Inertia Matrices for each link. 6 by 6 by n 
%          S - Screw Axis. 6 by n 

% Output - Torques n by 1 

theta = flipVec(theta);thetad = flipVec(thetad); thetadd = flipVec(thetadd); g = flipVec(g);Ftip = flipVec(Ftip);
torques = [];
%validate input
if(~checkIfColVec(theta) || ~checkIfColVec(thetad) || ~checkIfColVec(thetadd) || ~checkIfColVec(g) || ~checkIfColVec(Ftip))
        disp('One of the inputs that is supposed to be a vector is not a vector');
    elseif(size(S, 1) ~= 6)
        disp('Screw axes not 6 dimensional');
    elseif(size(g,1)  ~= 3)
        disp('Invalid gravitational acceleraton vector. Has to be 3 by 1');
    elseif(size(Ftip, 1) ~= 6)
        disp('Invalid spatial force vector. Has to be 6 by 1');
    elseif(length(size(Mrel)) ~= 3 || length(size(G)) ~=  3)
        disp('The Mrel matrix or the Gi matrix are not 3 dimensional.');
    elseif(size(Mrel, 1) ~= size(Mrel, 2) || size(G,1) ~= size(G,2))
        disp('The Mrel or G matrices are not square');
    elseif(size(G, 1) ~= 6 || size(G, 2)~= 6)
        disp('The G Matrix is not 6 by 6');
    elseif(~CheckIfListIsSE3(Mrel))
        disp('The Mrel list contains at least one invalid SE3 matrix')
    elseif(~(CheckIfDimEqual(size(theta, 1),size(thetad, 1),size(thetadd, 1),size(Mrel, 3)-1,size(G, 3), size(S, 2))))
        disp('Mismatch in the number of joints in the inputs');
    else
        %Setup all the necessary stuff - M and A
        
        % For A, M, F, torques, index i tracks the ith link. For F, n+1 is Ftip
        %For V, Vd, index i+1 is the ith link. Therefore in the formula from the
        %book any V_i (referring to ith link's velocity) in code should be
        %replaced by V(i+1);
        n = size(theta, 1);
        M = zeros(4,4,n);
        M(:,:,1) = Mrel(:,:,1);
        for i=2:n %M0n = M01M12M34....Mn-1n %recursive way to compute Mi
            M(:,:,i) = M(:,:,i-1)*Mrel(:,:,i);
        end
        A = zeros(6,n);
        for i=1:n
            A(:,i) = Adjoint(TransInv(M(:,:,i)))*S(:,i);
        end
        
        
        V = zeros(6,n+1); %0,1,2,3,4,5,6 V(1) = zero velocity of the base frame. 
        Vd = zeros(6,n+1); %ith link is actually i+1 index
        Vd(:,1) = [zeros(3,1);-g]; %velocity of the base frame expressed in the base frame coordinates. gravity downwards is equivalent to the base accelerating upwards
        
        F = zeros(6, n+1); %since n+1 is Ftip, ith link is still ith index. 
        F(:,end) = Ftip;
        
        torques = zeros(n,1); %scalar values for each joint, initiliaze with zeros. 
        
        
        %Forward iteration
        for i=1:n %over number of links
            x = Mrel(:,:,i)*MatrixExp6(A(:,i)*theta(i));
            V(:,i+1) = Adjoint(TransInv(x))*V(:,i) + A(:,i)*thetad(i);
            Vd(:,i+1) = Adjoint(TransInv(x))*Vd(:,i) + LieBracket(V(:,i+1), A(:,i))*thetad(i) + A(:,i)*thetadd(i);
        end
        
        %Backward iteration
        for i=n:-1:1 % i is over link index
            if(i == n)
                x = TransInv(Mrel(:,:,i+1)); %T_i+1,i T76 = M67Inv
            else
                x = TransInv(Mrel(:,:,i+1)*MatrixExp6(A(:, i+1)*theta(i+1)));
            end
            
            F(:, i) = Adjoint(x)'*F(:,i+1) +  G(:,:,i)*Vd(:,i+1) - smallAd(V(:,i+1))'*(G(:,:,i)*V(:,i+1));
            torques(i) = F(:,i)'*A(:,i); 
        end
end


end


%%%%local utility functions. 
function [out] = flipVec(in)
    if(size(in, 2) > 1)
        out = in';
    else
        out = in;
    end
end

function [out] = checkIfColVec(in)
    if(size(in, 2) ~= 1)
        out = false;
    else
        out = true;
    end
end

function [out] = CheckIfListIsSE3(in)
    out = true;
    %we know in is at this stage three dimensional and that each matrix is
    %at least square. 
    
    n = size(in, 3); % num of matrices
    for i=1:n
        out = CheckIfValidSE3(in(:,:,i));
        if(out == false)
            break;
        end
    end
    
end

function [out] = CheckIfDimEqual(varargin)
    vec = cell2mat(varargin);
    out = all(vec == vec(1));
end