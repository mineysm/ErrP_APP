function [feature] =  feature_select_test(data,indPoint,selopt)
% data ->  samples* features
if selopt==1
for i=1:size(data,1)
    feat1=[];
    t=indPoint;  
    if ~isempty(t)
        feat1 = [feat1 squeeze(data(i,t))];
    end
    feature(i,:)=[feat1];

end
elseif selopt==0
      feature = data;
end

end