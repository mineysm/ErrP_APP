function [ztemporalTRAIN_t, ztemporalTRAIN_nt, totalnumfeat]= temporal_feature_extraction(ytarget_cn, trnlabel, norm)

% ytarget_cn ->  channel * time * trial
y_cn = permute(ytarget_cn, [2 1 3]);
%   time * channel * trial
[ttr,ntr, ktr] = size(y_cn);
z = reshape(y_cn, [ttr*ntr,ktr]);
ztemporalTRAIN_t = z(:,trnlabel == 1);
ztemporalTRAIN_nt = z(:,trnlabel == 2);
totalnumfeat= size(z,1);
if norm ==1
   ztemporalTRAIN_t = normalize2dData(ztemporalTRAIN_t);
    ztemporalTRAIN_nt = normalize2dData(ztemporalTRAIN_nt);
end
end