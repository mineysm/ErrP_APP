function y= xdawn_spatial_filter_projection (test_x,W,nc,norm)
 [trial, time, channel] = size(test_x); %38*256*12
test_x=permute(test_x,[3 2 1]);  %%[ channel, time, trial ]
test_tmp = reshape(test_x, [ channel, time*trial]);

data_test = test_tmp'*W;
ntest = reshape(data_test', [channel,time,trial ]); % 

% ntest=normalizeData(ntest);
y = [];
for i = 1:nc
		y = [y; squeeze(ntest(i, :, :))]; %512*38
       
end
if norm ==1
y=normalize2dData(y);
end
end




