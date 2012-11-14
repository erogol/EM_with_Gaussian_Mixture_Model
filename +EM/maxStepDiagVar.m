function [mu,sigmas,Z] = maxStepDiagVar(P,feats,nclass,ninst)
totalP = sum(P,1);
PXi = P'*feats;
mu = PXi./[totalP' totalP'];
nfeat = size(feats,2);

for i = 1:nclass
    sum_ = 0;
    sum_ = sum_ +P(:,i)'*sqrt(abs(bsxfun(@minus,feats,mu(i,:))));
    sum_ = sum_/totalP(1,i);
    sigmas(:,:,i) = diag(sum_)+0.000001;
end
Z = totalP / ninst;
end