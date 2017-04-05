clear all, clc;
d = 2;
N = 6;
c1 = [1,2,2;1,2,0];
c2 = [0, 1, 0; 0, 0, 1];
X = [c1, c2];
y = [ones(3,1); -1*ones(3,1)];

extY = repmat(y', d, 1);
nData = X.*extY;
tnData = nData';
mData = tnData*nData;

%For QP

f = -1*ones(N,1);
H = mData;
Aeq = y';
beq = zeros(1,1);
lb = zeros(N,1);
ub = 100*ones(N,1);
options = optimset('Algorithm', 'interior-point-convex');
lambda = quadprog(H,f,[], [], Aeq,beq, lb, ub, [], options)

w1 = sum(lambda.*y.*X(1,:)');
w2 = sum(lambda.*y.*X(2,:)');

w = [w1;w2];
w