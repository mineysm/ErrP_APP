function [win, idxs]=feature_selection(zfeat_t,zfeat_nt, feat_method, nfeat)

idxs=[];
ch=1;
for samp=1:size(zfeat_t, 2) %nr de amostras temporais
    x1(1,samp,:)=zfeat_t(:,samp);        %serve apenas para colocar os dados num formato id�ntico a ztarget
    x2(1,samp,:)=zfeat_nt(:,samp);
end

   if feat_method == 1
   for samp=1:size(x2, 2) %nr de amostras temporais
       ressq(samp, ch)=rsquare(x1(ch, samp,:),x2(ch, samp,:));
         end
[ord, ind]=sort(ressq(:,ch),'descend');
win=ind(1:nfeat);

elseif feat_method == 2
%
end


end