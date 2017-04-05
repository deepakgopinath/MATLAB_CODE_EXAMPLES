clear all;
load fisheriris;
meanMatrix =  [5.0060    3.4280    1.4620    0.2460;
              5.9360    2.7700    4.2600    1.3260;
              6.5880    2.9740    5.5520    2.0260];
covMegaMatrix = zeros(4,4,3);

%case 1. keep structure the same. So don't update the sigma. 
k = 3;

%case 1
% covMegaMatrix(:,:,1) = rand()*eye(4);
% covMegaMatrix(:,:,2) = rand()*eye(4);
% covMegaMatrix(:,:,3) = rand()*eye(4);

%case 2
% covMegaMatrix(:,:,1) = diag(rand(4,1));
% covMegaMatrix(:,:,2) = diag(rand(4,1));
% covMegaMatrix(:,:,3) = diag(rand(4,1));

%case 3
% Q = randn(4,4);
% A = Q' * diag(abs(randn(4,1)*0.5)) * Q;
% covMegaMatrix(:,:,1) = A;
% covMegaMatrix(:,:,2) = covMegaMatrix(:,:,1);
% covMegaMatrix(:,:,3) = covMegaMatrix(:,:,1);

%case 4
Q = randn(4,4);
A = Q' * diag(abs(randn(4,1))) * Q;
covMegaMatrix(:,:,1) = A;
Q = randn(4,4);
A = Q' * diag(abs(randn(4,1))) * Q;
covMegaMatrix(:,:,2) = A;
Q = randn(4,4);
A = Q' * diag(abs(randn(4,1))) * Q;
covMegaMatrix(:,:,3) = A;

pis = [ 1/3, 1/3, 1/3];

[p, m, s] = gmmClustering(meas, k, meanMatrix, covMegaMatrix, pis);

labels = [1*ones(50,1); 2*ones(50,1); 3*ones(50,1)];
figure;
scatter(meas(1:50, 1), meas(1:50, 2), 'r')
hold on
scatter(meas(51:100, 1), meas(51:100,2), 'g')
hold on
scatter(meas(101:150, 1), meas(101:150, 2), 'b')
xlabel('Sepal Length');
ylabel('Sepal Width');
hold on;
color = ['r', 'g', 'b'];
for n=1:k
    CovSLSW = s(1:2,1:2,n);
    [v, d] = eig(CovSLSW);
    center = m(n, 1:2)';
    semiMajorAxis = sqrt(d(1,1));
    semiMinorAxis = sqrt(d(2,2));
    angle = atan(v(2,1)/v(1,1));
    ellipse(semiMajorAxis, semiMinorAxis, angle, center(1), center(2), color(n));
    hold on
end
