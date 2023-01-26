function [feature]=ac_ErrP_feature(data,indPoint,id)

% projection
    for i=1:size(data,1)
        feat1=[];
        t=indPoint;
        
        if ~isempty(t)
            feat1 = [feat1 squeeze(data(i,t))];
        end
        feature(i,:)=[feat1];
    end

end

