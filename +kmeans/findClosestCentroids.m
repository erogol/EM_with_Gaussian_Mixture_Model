function idx = findClosestCentroids(X, centroids)

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

m = size(X, 1);

for i=1:m,
    distance_array = zeros(1, K);
    for j=1:K,
        distance_array(1,j) = sum((X(i,:)-centroids(j,:)).^2);
    end;
    [d, d_idx] = min(distance_array);
    idx(i,1) = d_idx;
end

end