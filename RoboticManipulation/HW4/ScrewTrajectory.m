function [ SEList ] = ScrewTrajectory(X_s, X_end, T, N, tsMethod)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
SEList = [];
if(CheckIfValidSE3(X_s) == false || CheckIfValidSE3(X_end) == false)
    disp('Start or end transformation matrices are not valid')
elseif(tsMethod ~=3 && tsMethod ~= 5)
    disp('Please enter 3 for cubic, or 5 for Quintic Time Scaling')
elseif(N < 2)
    disp('Enter number of steps to be greater than or equal to 2')
elseif(T <= 0)
    disp('Invalid total Time. Has to be positive ');
else
    if(tsMethod == 3)
     timescalingmethod = @CubicTimeScaling;
        elseif(tsMethod == 5)
     timescalingmethod = @QuinticTimeScaling;
    end
    step = T/(N-1);
    t = (0:step:T)';
    s_t = timescalingmethod(T, t); %generate s(t), column vector, N
    SEList = zeros(4,4,N); % List of SE(3) matrices
    logArg = MatrixLog6(TransInv(X_s)*X_end); % 6 by 1
    for i=1:N
        SEList(:,:,i) = X_s*MatrixExp6(logArg*s_t(i)); % s_t(i) is a scalar. 
    end
    
end


end

