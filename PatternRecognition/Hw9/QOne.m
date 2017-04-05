clear all; clc;
data1 = [-5, -5, -4, -5, -6;-5, -4, -5, -6, -5]';
data2 = [5,5,6,5,4;5,6,5,4,5]';

c1 = cov(data1);
c2 = cov(data2);

%we know that the covariances are equal. And the assumption is that the
%data came from gaussians. And also the priors are the same
m1 = mean(data1);
m2 = mean(data2);

w = inv(c1)*(m1 - m2)'; 

modData1 = sum(repmat(w', 5, 1).*data1, 2);
modData2 = sum(repmat(w', 5, 1).*data2, 2);




