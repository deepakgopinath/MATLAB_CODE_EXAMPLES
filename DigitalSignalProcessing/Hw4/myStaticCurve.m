% MUSI 6202 HW4 - Static curve
% CW @ GTCMT 2015
% objective: compute control signal F for adjusting gain
% F = myStaticCurve(X, LS, LT)
% X = float N*1 vector, input value in log scale
% LS = float scalar, limiter slope
% LT = float scalar, limiter threshold
% F = float N*1 vector, output value in log scale

function F = myStaticCurve(X, LS, LT)

% initialization
N = length(X);
F = zeros(N, 1);
% write your code here 
F(X < LT) = 0;
F(X >= LT) = LS.*(LT - X(X >= LT));
