function [index] = BayesEstimation(data,model)
n = size(data,1);
nclass = size(model,2);
K = size(model{1}.mu_,1);
feat_vec = data(:,1:(end-1));

P = zeros(n,K);
lh_each_class = zeros(n,nclass);
for k = 1:nclass
    mu_ = model{k}.mu_;
    sigmas = model{k}.Sigmas;
    priors = model{k}.priors;
    
    for i = 1:K
        P(:,i) = mvnpdf(feat_vec,mu_(i,:),sigmas(:,:,i))*priors(i);
    end
    
    % Evaluation with log likelihood
    lh_each_class(:,k) = log(sum(bsxfun(@times,P,priors),2));
    %fprintf('Loglikelihood is %f\n',lh);
    %fprintf('Likelihood change is %f\n',lh-old_lh);
 
end

[~,index]=max(lh_each_class');
end