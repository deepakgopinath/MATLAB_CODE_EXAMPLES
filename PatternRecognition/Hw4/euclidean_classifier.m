function z = euclidean_classifier(m , X) % m is the mean vector
    [l,c] = size(m); % dimnesionality
    [l, N] = size(X); % number of data vectors
    for i=1:N
        for j=1:c
            t(j) = sqrt((X(:,i) - m(:,j))'*(X(:,i) - m(:,j)));
        end
        [num, z(i)] = min(t);
    end
end