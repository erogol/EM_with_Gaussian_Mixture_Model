function [mu,sigmas,Z] = maxStepEqVar(P,feats,nclass,ninst)
totalP = sum(P,1);
PXi = P'*feats;
mu = PXi./[totalP' totalP'];
nfeat = size(feats,2);

for i = 1:nclass
    sum_ = 0;
    for j = 1:ninst
        sum_ = sum_ + P(j,i)*norm(feats(j,:)-mu(i,:))^2;
    end
    sum_ = sum_/(nfeat*totalP(1,i));
    sigmas(:,:,i) = diag([sum_,sum_]);
end
Z = totalP / ninst;
end