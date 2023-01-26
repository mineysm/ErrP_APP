function [y]=fcb_spatial_filter_projection(xchannels,U_all, nc, norm)
%xchannels: (events,samples,channel)
%y: events x samples

    for i=1:size(xchannels,1)   
        aux(:,:)=xchannels(i,:,:);
        aux1=aux';  
        Z=U_all'*aux1; 
        for j=1:nc
             ntest(j,:,i)=Z(j,:); 
        end
    end
 
y = [];
for i = 1:nc
		y = [y; squeeze(ntest(i, :, :))];     
end

if norm ==1
y=normalize2dData(y);
end


end



  