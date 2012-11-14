function centroids = computeCentroids(X, idx, K)

[m n] = size(X);

% You need to return the following variables correctly.
centroids = zeros(K, n);

for i=1:K,
    idx_k = (idx == i);
    C_k = sum(idx_k);
    idx_matrix = repmat(idx_k,1,n);
    X_k = X .* idx_matrix;
    centroids(i,:) = sum(X_k)./C_k;
end

end

