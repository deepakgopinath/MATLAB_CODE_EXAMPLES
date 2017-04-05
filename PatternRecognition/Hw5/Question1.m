clear all;

mu1 = [0;0;0];
cov1 = toeplitz([2,1,0]);

mu2 = [1;1;1];
cov2 = eye(3);

Cinv = (inv(cov1) + inv(cov2))/2;

Md = (mu1-mu2)'*Cinv*(mu1-mu2);

fprintf('The mahalanobis distance is %f\n\n\n', Md);

lowerLimit = sqrt(Md)/2;
error = 1 - normcdf(lowerLimit);

confusionMatrix = [1-error error; error 1-error];

max_iter = 10000;

disp('The confusion matrix from mahalanobis is');
confusionMatrix

C = inv(Cinv);
cumulative = zeros(2,2);
labels1 = ones(5000,1);
labels2 = ones(5000,1)*2;
labels = [labels1; labels2];
 probVals = zeros(10000, 2);
for i=1:max_iter
    
    data1 = mvnrnd(mu1, C,5000);
    data2 = mvnrnd(mu2, C, 5000);
    data= [data1;data2];
    probVals = [mvnpdf(data, mu1', C) mvnpdf(data, mu2', C)];

    [c,i] = max(probVals, [], 2);

    confuse1 = confusionmat(labels1, i(1:5000))/5000;
    confuse2 = confusionmat(labels2, i(5001:10000))/5000;
    confuse = confuse1 + confuse2;
    cumulative = cumulative + confuse;
end

cumulative = cumulative/max_iter;
disp('The error matrix is ');
cumulative
