function [mu,sigmas,Z] = maxStepArbVar(P,feats,nclass,ninst)
totalP = sum(P,1);
PXi = P'*feats;
mu = PXi./[totalP' totalP'];
nfeat = size(feats,2);
for i = 1:nclass
    sum_ = 0;
    temp = bsxfun(@minus,feats,mu(i,:));
    temp = bsxfun(@times,temp,sqrt(P(:,i)));
    temp = temp'*temp;
    sigmas(:,:,i) = temp/totalP(1,i);
end
Z = totalP / ninst;
end