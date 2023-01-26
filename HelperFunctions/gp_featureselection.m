function [feat_sel, idxs]=gp_featureselection(x1,x2,metodo,nfeat,pl)

if metodo == 1
   for samp=1:size(x2, 2) %nr de amostras temporais
       ressq(samp, ch)=rsquare(x1(ch, samp,:),x2(ch, samp,:));
         end
[ord, ind]=sort(ressq(:,ch),'descend');
feat_sel=ind(1:nfeat);

elseif metodo == 2

end

