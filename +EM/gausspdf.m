function p=gausspdf(x, mu, C)

n = size(x,1); % vector size
M = size(x,2); % number of inputs

if nargin < 3
    C = eye(n);
    if nargin < 2;
        mu = ones(n,1);
    end
end

x = x - mu*ones(1,M);

logdenom = -log((2*pi)^(n/2)*sqrt(abs(det(C))));
invC = inv(C);
mahal=sum((x'*invC).*x',2);
p = logdenom-0.5*mahal;
p = p';
end