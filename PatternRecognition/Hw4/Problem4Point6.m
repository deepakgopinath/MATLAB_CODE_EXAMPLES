clear all; clc;

PosData = [2 10;1 13; 5 13;4 15 ; 8 16; 7 19; 10 20; 9 22];
NegData = [6 12; 7 8;8 5; 8 11; 9 3;10 8; 11 6; 12 2];
TotData = [PosData; NegData];

%part one;

Means = mean(TotData);
disp('The mean for total')
Means
sigmaVec = sum((TotData - repmat(Means, length(TotData), 1)).^2)*(1/(length(TotData)- 1));
disp('The covariance matrix is');
covMatrix1 = diag(sigmaVec)

% part two

diff = (TotData - repmat(Means, length(TotData), 1));
covMatrix2 = zeros(2,2);
for i=1:length(TotData)
    x = diff(i,:)' * diff(i, :);
    covMatrix2 = covMatrix2 + x;
end

covMatrix2 = covMatrix2./(length(TotData) - 1);
disp('The total covariance matrix is');
covMatrix2

%part three

meansPlus = mean(PosData);
disp('The mean for class +')
meansPlus
diffPlus = (PosData - repmat(meansPlus, length(PosData), 1));
covMatrix3Plus = zeros(2,2);
for i=1:length(PosData)
    x = diffPlus(i,:)' * diffPlus(i, :);
    covMatrix3Plus = covMatrix3Plus + x;
end
covMatrix3Plus = covMatrix3Plus./(length(PosData) - 1);
disp('The Plus covariance matrix is');
covMatrix3Plus

meansMinus = mean(NegData);
disp('The mean for class -')
meansMinus
diffMinus = (NegData - repmat(meansMinus, length(NegData),1 ));
covMatrix3Minus = zeros(2,2);
for i=1:length(NegData)
    z = diffMinus(i,:)'* diffMinus(i,:);
    covMatrix3Minus = covMatrix3Minus + z;
end
covMatrix3Minus = covMatrix3Minus./(length(NegData) - 1);
disp('The minus covariance matrix is');
covMatrix3Minus


% decisions boundaries for the same.

%Part one - Linear decision boundary because c1= c2 = C

Q1 = 2*(meansMinus - meansPlus)*inv(covMatrix1);
Q2 = ( meansPlus*inv(covMatrix1)*meansPlus' - meansMinus*inv(covMatrix1)*meansMinus');
%part two 

Q1 = 2*(meansMinus - meansPlus)*inv(covMatrix2);
Q2 = ( meansPlus*inv(covMatrix2)*meansPlus' - meansMinus*inv(covMatrix2)*meansMinus');

%part three

Q0 = inv(covMatrix3Plus) - inv(covMatrix3Minus);
Q1 = 2*(meansMinus*inv(covMatrix3Minus) - meansPlus*inv(covMatrix3Plus));
Q2 = (meansPlus*inv(covMatrix3Plus)*meansPlus' - meansMinus*inv(covMatrix3Minus)*meansMinus');