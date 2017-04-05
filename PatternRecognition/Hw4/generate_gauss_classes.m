function [X,y]=generate_gauss_classes(m,S,P,N)

% m is an l by c matrix, the i-th column of which is the mean vector of the
% i-th class distribution.
% S is an l by l X c (three-dimensional) matrix, whose ith two-dimensional l ? l component is the covariance of the distribution of the ith class. In MATLAB S(:, :, i) denotes the i-th two-dimensional l ? l matrix of S.
% P is the c dimensional vector that contains the a priori probabilities of the classes. mi, Si, Pi,and c are provided as inputs.
% The following function returns:

% A matrix X with(approximately)Ncolumns,each columnof which is
% an l-dimensional data vector.
% s A row vector y whose ith entry denotes the class from which the ith
% data vector stems.
    [l,c]=size(m);
    X=[];
    y=[];
    for j=1:c
        % Generating the [p(j)*N)] vectors from each distribution
        t=mvnrnd(m(:,j),S(:,:,j),fix(P(j)*N));
%         size(t)
%         size(t')
        % The total number of points may be slightly less than N % due to the fix operator
        X=[X t'];
        y=[y ones(1,fix(P(j)*N))*j];
    end
end