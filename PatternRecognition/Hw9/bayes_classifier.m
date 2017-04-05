function z= bayes_classifier(m, S, P, X)
    [l,c] = size(m); % dimnesionality
    [l, N] = size(X); % number of data vectors
    for i=1:N
        for j=1:c
            t(j) = P(j) * comp_gauss_dens_val(m(:,j), S(:,:,j), X(:,i));
        end
        [num, z(i)] = max(t);
    end
end