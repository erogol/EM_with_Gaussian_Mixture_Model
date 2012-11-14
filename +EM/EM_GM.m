function [model,lh] = EM_GM(data,K, nfeat, threshold ...
    ,variance_type,max_iter,k_means, plot_flag,slient)
% EM algorithm on Gaussian Mixture model
% Eren Golge - Nov 2012
%
% file - data file path
% K - number of density components
% nfeat - number features
% threshold - value for checking convergence with loglikelihood
% variacen_type - 1=equal diagonals, 2=diagonal, 3=arbitary
% max_ite - maximum iteration algorithm that might have
% k_means - init algorithm with k-means or random sampling.
% plot_flag - plot the resulting gaussian.
% slient - if 0 no output

%% Parameter Tuning
tic;
import EM.*
import plotting.*
import kmeans.*

feats = data(:,1:2);
ninst = size(data,1);
nclass = num_of_classes(data,size(data,2));

% FIND the NUMBER OF CLASSES

%% Init parameters
if k_means
    %RUN K-means
    C = init_centroids(feats,K);
    [mu_,~] = kmeans(feats,C,2,0);
else
    %SELECT RANDOM DATA POINTS AS INTIAL MU VALUES (alternative to knmeans)
    indices = randsample(ninst,K);
    C = feats(indices,:);
end
%init covariance for the case 1 - spherical covariance.
sigmas = zeros(nfeat,nfeat,K);
idx = EM.findClosestCentroids(feats,C);

% Init the prob matrix P and latent variable vector Z
% Each ixj element shows for instance j prop. of being
%the member of class i
P = full(sparse(1:ninst,idx,1,ninst,K,ninst));
Z = ones(K,1)./K;
lh = 0;

%% EM algorithm
converge_flag = 0;
iter = 0;
while converge_flag == 0 && iter < max_iter
    
    % M-step
    if variance_type == 1
        [mu_,sigmas,Z] = EM.maxStepEqVar(P,feats,K,ninst);
    elseif variance_type == 2
        [mu_,sigmas,Z] = maxStepDiagVar(P,feats,K,ninst);
    else
        [mu_,sigmas,Z] = maxStepArbVar(P,feats,K,ninst);
    end
      
    % E-step
    for i = 1:K
        P(:,i) = mvnpdf(feats,mu_(i,:),sigmas(:,:,i))*Z(i);
    end
    temp = sum(P,2);
    for i = 1:K
        P(:,i) = P(:,i)./temp;
    end
    
    % Evaluation with log likelihood
    old_lh = lh;
    lh = sum(log(sum(bsxfun(@times,P,Z),2)));
    if ~slient
        fprintf('Loglikelihood is %f\n',lh);
        fprintf('Likelihood change is %f\n',lh-old_lh);
    end
    if((abs(lh-old_lh) < threshold*abs(lh) && iter ~= 0)||iter == max_iter)
        converge_flag = 1;
    end
    iter = iter + 1;
end

if plot_flag
    figure(1);
    hold on;
    plotDataPoints(feats,data(:,end), 3);
    plot(mu_(:,1),mu_(:,2),'Xb','MarkerSize', 10,'LineWidth', 1);
    colors = {'b','c','m','g'};
    for i = 1:K
        h1 = plot_gaussian_ellipsoid(mu_(i,:),sigmas(:,:,i),1);
        set(h1,'color', colors{1}, 'LineWidth', 3);
    end
    hold off;
end

model.Sigmas = sigmas;
model.mu_ = mu_;
model.priors = Z;
fprintf('Execution ended in %f secs with %d iteration.\n',toc,iter);

end
