clear all;clc;
d = 2;
N = 4;
c1 = [-1, 1; -1, 1 ];
c2 = [-1, 1; 1, -1];
y = [-1*ones(2, 1); ones(2,1)];
X = [c1, c2];

K = (X'*X + 1).^2;
corrMatrix = (y*y').* K;


% for QP;

f = -1*ones(N,1);
H = corrMatrix;
Aeq = y';
beq = zeros(1,1);
lb = zeros(N,1);
ub = 100*ones(N,1);
options = optimset('Algorithm', 'interior-point-convex');
lambda = quadprog(H,f,[], [], Aeq,beq, lb, ub, [], options)

dNew = 6;
XNew = zeros(dNew, N);
for i=1:N
    XNew(:,i) = transform(X(:,i));
end
wFinal = zeros(dNew, 1);
for i=1:dNew
    wFinal(i) = sum(lambda.*y.*XNew(i,:)');
end
wFinal