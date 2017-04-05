clear all
load fisheriris

%red - species 1, green - species 2, blue - species 3
number_of_species = 3;
%question number 1
labels = [1*ones(50,1); 2*ones(50,1); 3*ones(50,1)];
figure;
scatter(meas(1:50, 1), meas(1:50, 2), 'r')
hold on
scatter(meas(51:100, 1), meas(51:100,2), 'g')
hold on
scatter(meas(101:150, 1), meas(101:150, 2), 'b')
xlabel('Sepal Length');
ylabel('Sepal Width');

%question number 2
meanMatrix = zeros(3,4); %rows represent species, columns represent features
covMegaMatrix = zeros(4,4,3); % each one of the 4 by 4 matrix is for each species
disp('Rows represent species and columns represent features');

for n=1:number_of_species
    for m=1:size(meas,2)
        meanMatrix(n,m) = mean(meas((n-1)*50 + 1:n*50, m));
    end
    covMegaMatrix(:,:,n) = cov(meas((n-1)*50 + 1:n*50,:));
end
color = ['r', 'g', 'b'];
meanMatrix
disp('each one of the 4 by 4 matrix is for each species')
covMegaMatrix


%one -sigma curve
figure;
for n=1:number_of_species
    CovSLSW = covMegaMatrix(1:2,1:2,n);
    [v, d] = eig(CovSLSW);
    center = meanMatrix(n, 1:2)';
    semiMajorAxis = sqrt(d(1,1));
    semiMinorAxis = sqrt(d(2,2));
    angle = atan(v(2,1)/v(1,1));
    ellipse(semiMajorAxis, semiMinorAxis, angle, center(1), center(2), color(n));
    hold on
end

% minimum distance classifier
distance = zeros(150,3);
mdCLabels = zeros(150, 1);
for n=1:number_of_species
    for m = 1:size(meas,1)
        distance(m, n) = sqrt(sum((meas(m,:) - meanMatrix(n, :)).^2));
    end
end
[x, mdCLabels] = min(distance, [], 2);
disp('Confusion Matrix is')
confusionMatrix = confusionmat(labels, mdCLabels)