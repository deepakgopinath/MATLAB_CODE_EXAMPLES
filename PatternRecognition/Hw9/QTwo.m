clear all;clc;
load fisheriris;
num_of_classes = 3;
num_of_features = size(meas, 2);
labels = [1*ones(50,1); 2*ones(50,1); 3*ones(50,1)];
c = cov(meas);
eigVec = pca(meas);
%For 3d. Pick the first 3 eigenvectors and transform data;

modData3d = ((eigVec(:,1:3)')*meas')';
modData2d = ((eigVec(:,1:2)')*meas')';
modData1d = ((eigVec(:,1:1)')*meas')';

%3d case;

meanMatrix = zeros(3,3); %rows represent species, columns represent features
covMegaMatrix = zeros(3,3,3); % each one of the 4 by 4 matrix is for each species
priors = [1/3;1/3;1/3];
for n=1:num_of_classes
    for m=1:size(modData3d,2)
        meanMatrix(n,m) = mean(modData3d((n-1)*50 + 1:n*50, m));
    end
    covMegaMatrix(:,:,n) = cov(modData3d((n-1)*50 + 1:n*50,:));
end
bayesLabels = bayes_classifier(meanMatrix', covMegaMatrix, priors,modData3d'); 
disp('Confusion Matrix is')
confusionMatrix = confusionmat(labels, bayesLabels)

%for 2d.
meanMatrix = zeros(3,2); %rows represent species, columns represent features
covMegaMatrix = zeros(2,2,3); % each one of the 4 by 4 matrix is for each species
priors = [1/3;1/3;1/3];
for n=1:num_of_classes
    for m=1:size(modData2d,2)
        meanMatrix(n,m) = mean(modData2d((n-1)*50 + 1:n*50, m));
    end
    covMegaMatrix(:,:,n) = cov(modData2d((n-1)*50 + 1:n*50,:));
end
bayesLabels = bayes_classifier(meanMatrix', covMegaMatrix, priors,modData2d'); 
disp('Confusion Matrix is')
confusionMatrix = confusionmat(labels, bayesLabels)

%for 1d;

meanMatrix = zeros(3,1); %rows represent species, columns represent features
covMegaMatrix = zeros(1,1,3); % each one of the 4 by 4 matrix is for each species
priors = [1/3;1/3;1/3];
for n=1:num_of_classes
    for m=1:size(modData1d,2)
        meanMatrix(n,m) = mean(modData1d((n-1)*50 + 1:n*50, m));
    end
    covMegaMatrix(:,:,n) = cov(modData1d((n-1)*50 + 1:n*50,:));
end
bayesLabels = bayes_classifier(meanMatrix', covMegaMatrix, priors,modData1d'); 

disp('Confusion Matrix is')
confusionMatrix = confusionmat(labels, bayesLabels)


%9.2 c
clear all;clc;

load fisheriris;
data1 = meas(51:100, :);
data2 = meas(101:150, :);
c1 = cov(data1);
c2 = cov(data2);
m1 = mean(data1);
m2 = mean(data2);
labels = [1*ones(50,1); 2*ones(50,1)];
%priors are equal

[x, y]= eig(inv(c2)*(c1 + (m1-m2)'*(m1-m2)));
eigVals = zeros(4,1);
for i=1:4
    eigVals(i) = y(i,i);
end

maxCol = find(eigVals == max(eigVals));
w = x(:, maxCol);
num_of_classes = 2;
modData1 = repmat(w', 50, 1).*data1;
modData2 = repmat(w', 50, 1).*data2;
modData1d = [modData1; modData2];
meanMatrix = zeros(2,4); %rows represent species, columns represent features
covMegaMatrix = zeros(4,4,2); % each one of the 4 by 4 matrix is for each species
priors = [1/2;1/2];
for n=1:num_of_classes
    for m=1:size(modData1d,2)
        meanMatrix(n,m) = mean(modData1d((n-1)*50 + 1:n*50, m));
    end
    covMegaMatrix(:,:,n) = cov(modData1d((n-1)*50 + 1:n*50,:));
end
bayesLabels = bayes_classifier(meanMatrix', covMegaMatrix, priors,modData1d'); 

disp('Confusion Matrix is')
confusionMatrix = confusionmat(labels, bayesLabels)




