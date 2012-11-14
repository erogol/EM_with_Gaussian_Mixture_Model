import EM.*
import kmeans.*
import Plotting.*

%PROGRAM PARAMETERS
clear;
file = 'cs551_hw2_q1.dat';
ccolumn = 3;
nfeat = 2;
threshold = 1e-5;
max_iter = 2000;
k_means = 0;
covarType = 3; % 1 - sigma*I    2 - diagonal    3 - Arbitary 
nclass = 3;
plotting = 1; % plot gaussians if 1
slientEM = 1; % no output on EM process if 1
%K = 1;

% READ DATA
[data,ncolumns]=read_format_data(file, ' ');

%CREATE TEST and TRAIN DATA
data_labels = data(:,end);
index1 = find(data_labels == 1);
index2 = find(data_labels == 2);
index3 = find(data_labels == 3);

class1Data = data(index1,:);
class2Data = data(index2,:);
class3Data = data(index3,:);

indices = randsample(1000,500);
train1 = class1Data(indices,:);
test1 = class1Data(setdiff(1:1000,indices),:);

indices = randsample(1000,500);
train2 = class2Data(indices,:);
test2 = class2Data(setdiff(1:1000,indices),:);

indices = randsample(1000,500);
train3 = class3Data(indices,:);
test3 = class3Data(setdiff(1:1000,indices),:);

clear('class3Data','class2Data','class1Data','indices');

% run EM for different component numbers
for K = 1 : 2 : 11
    fprintf('************ Classifier %f For Component Number %f \n',covarType,K);
    
    %% EM estimation step
    train_data = {train1,train2,train3};
    model = {};
    likelihood = [];
    for t = 1 : nclass
        if ~exist(['model' t '.mat'], 'file')
            [model{t},likelihood(t)] = EM_GM(train_data{t},K,nfeat,threshold,covarType,max_iter,k_means,plotting,slientEM);
        else
            load(['model' t '.mat']);
        end
    end
    
    for t = 1:nclass
        fprintf('Estimated parameters for class %d (K = %d & Classifier = %d) \n',t, K, covarType);
        fprintf('mu');display(model{t}.mu_);
        fprintf('Covars');display(model{t}.Sigmas);
        fprintf('Priors');display(model{t}.priors);
        fprintf('Final Loglikelihood : ');display(likelihood(t));
    end
    
    fprintf('Press any button to cont.**********************\n');
    pause;
    close all; %close open figure for next iteration
    %% Bayesian Estimation
    % test data
    testData = [test1;test2;test3];
    labels = BayesEstimation(testData,model);
    C = confusionmat(testData(:,end),labels);
    fprintf('\nConfusion matrix of test data \n');
    display(C);
    
    % train data
    train_data = [train1;train2;train3];
    labels = BayesEstimation(train_data,model);
    C = confusionmat(testData(:,end),labels);
    fprintf('Confusion matrix of train data \n');
    display(C);
    fprintf('Press any button to cont.**********************\n');
    pause;
end