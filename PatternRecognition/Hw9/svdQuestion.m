clear all; clc;
data = [0 0 1 1 0 0 0 0 0;
        0 0 0 0 0 1 0 0 1;
        0 1 0 0 0 0 0 1 0;
        0 0 0 0 0 0 1 0 1;
        1 0 0 0 0 1 0 0 0;
        1 1 1 1 1 1 1 1 1;
        1 0 1 0 0 0 0 0 0;
        0 0 0 0 0 0 1 0 1;
        0 0 0 0 0 2 0 0 1;
        1 0 1 0 0 0 0 1 0;
        0 0 0 1 1 0 0 0 0;
        ];
[u,s,w] = svd(data);
disp('The u, s and w matrices are');
u
s
w

%for pca

data = data'; %so that rows correspond to observations, columns to variables
x = pca(data);
[p, q] = eig(cov(data));
var = zeros(11,1);
for i=1:11
    var(i) = q(i,i);
end
var = sort(var, 'descend');
disp('The top three variances cover');
var(1)/sum(var)
var(2)/sum(var)
var(3)/sum(var)
disp('percentage of the total variance');

%for X3

u3 = u(:,1:3);
s3 = s(1:3,1:3);
w3 = w(:, 1:3);

x3 = u3*s3*w3';
disp('The approx of X using 3 singular values is');
x3

iS = inv(s3);

modData = zeros(9,3);
for i=1:size(data,1)
    modData(i,:) = (iS*u3'*data(i,:)')';
end

dist = pdist(modData,'cosine');
% dist =dist;
disp('The distance between the points is given by the matrix');
dist = squareform(dist)



disp('From inspection of the distance matrix between all titles the closest titles (the distances are least) are T4 and T5')
