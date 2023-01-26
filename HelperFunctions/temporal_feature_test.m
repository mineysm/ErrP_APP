function [ztest]= temporal_feature_test(ytarget_id, norm)
% k*t*n
y_tnk= permute(ytarget_id, [2 3 1]); 
%t*n*k
[ttr,ntr, ktr] = size(y_tnk);
ztest = reshape(y_tnk, [ttr*ntr,ktr]);
if norm ==1
ztest=normalize2dData(ztest);
end
end