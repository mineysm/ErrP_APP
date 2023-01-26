%%
function [train_x_t, train_x_nt, xdawnfilter, totalnumfeat]= xdawn_feature_extraction(X,train_y, nc, norm)
fprintf('Extracting xDAWN features \n')
 [n, t, k] = size(X); %[ channel, time, trial ]

stimulus_idx = 1:t:k*t;

targetidx = find(train_y == 1);
nontargetidx = find(train_y == 2);
stimulus_idx(nontargetidx) = [];

train_data = reshape(X, [n, t*k]);
train_data = double(train_data');

xdawnfilter = xdawn_spatial_filters(train_data,t,stimulus_idx);

filtereddata = train_data*xdawnfilter;

train = reshape(filtereddata', [n, t, k]);

ntrain=train;
%ntrain=normalizeData(train);

train_t = ntrain(:,:,targetidx);
train_nt = ntrain(:,:,nontargetidx);

train_x_t = [];
train_x_nt = [];
	for i = 1:nc
		train_x_t = [train_x_t; squeeze(train_t(i, :, :))];    
        train_x_nt = [train_x_nt; squeeze(train_nt(i, :, :))];    

    end
     totalnumfeat= size(train_x_t,1);
    if norm ==1
    train_x_t=normalize2dData(train_x_t);
    train_x_nt=normalize2dData(train_x_nt);
    end


end
