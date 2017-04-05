function [ pik, mu, sigma ] = gmmClustering( data, k, initialMu, initialSigma, initialPik )
%This function returns the wieghts, the means and variances of k gaussians

% k is the number of gaussians in mixture
% D is the dimensionality of the data
% N is the number of data points


% mu - k by D matrix
% sigma - D by D by k
% pik = 1 by k

%data  - N by D matrix.


[N, D] = size(data);

% initializations;

mu = zeros(k, D);
sigma = zeros(D,D,k);
pik = zeros(1, k);


mu = initialMu;
sigma = initialSigma;
pik = initialPik;

GaussDist = zeros(N, k); %To store the gaussian probabilities of each data point and each component
max_iter = 1000;
for i=1:max_iter
    %Step to compute the gaussian probability for each data point and each
    %component
    for c=1:k % only iterating over components. Filling the GaussDist colum by column
        currentMu = mu(c, :); %row vector of size 1 by D
        currentSigma = sigma(:,:,c); %D by D
        GaussDist(:, c) = mvnpdf(data,currentMu,currentSigma) + realmin; % N by 1 %realmin to avoid underflow errors
    end
    
    %E step
    
    %evaluation of p(k|x_j) - This is used in the update equations of all
    %parameters
    
    %this should be a N by k matrix. For every nth data point and every kth
    %component
    
    pikRep = repmat(pik, N, 1); %N by k
%     pKGivenXjNum = pikRep.*GaussDist; % N by k
%     pKGivenXjDen = sum(pikRep.*GaussDist, 2); % N by 1
    pKGivenXj = (pikRep.*GaussDist)./ repmat(sum(pikRep.*GaussDist, 2), 1, k); % N by k;
    %pKGivenXj is same as gamma in Bishop book;
    Nk = sum(pKGivenXj,1); %1 by k
    pik = Nk./N; % 1 by k; k new weights
    
    for c=1:k
        % calculate new sigmas first so that the mu s can be used before
        % they are updated. 
        % calculation of new mu's dont need new sigmas. Can be dont
        % directly from pKGivenXj and Xj. 
        
        %udating sigma
        currentMu = mu(c,:); %1 by D
        xMinusCurrentMu = data - repmat(currentMu, N, 1); % N by D
        xMinusCurrentMuTimesPkGivenXj = xMinusCurrentMu .* repmat(pKGivenXj(:, c), 1, D);
        % New sigma 
        sigma(:, :, c) = (xMinusCurrentMuTimesPkGivenXj'*xMinusCurrentMu)/Nk(c);
        
        %new mu calculation
        multipliedData = data.*repmat(pKGivenXj(:, c), 1, D); %N by k
        sumMultData = sum(multipliedData, 1); %1 by k
        mu(c, :) = sumMultData/Nk(c); % 1 by k;
    end
    
end



end

