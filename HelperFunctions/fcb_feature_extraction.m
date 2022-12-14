function [zspatialTRAIN_t, zspatialTRAIN_nt, Uall, P, totalnumfeat] =  fcb_feature_extraction(ztargetTRAIN,znontargetTRAIN, nchan, nc,norm)
    
    [Uall, P] = FCB_spatial_filters(ztargetTRAIN, znontargetTRAIN, 0.1); 

    % Projections obtained from spatial filters
    [ytf, yntf]= FCB_projections(ztargetTRAIN, znontargetTRAIN,Uall); 

    zspatialTRAIN_t = [];
    zspatialTRAIN_nt = [];
    for i = 1:nc
		zspatialTRAIN_t = [zspatialTRAIN_t; squeeze(ytf(i, :, :))]; 
        zspatialTRAIN_nt = [zspatialTRAIN_nt; squeeze(yntf(i, :, :))]; 
    end

    totalnumfeat= size(zspatialTRAIN_t,1);                    
    if norm==1
    zspatialTRAIN_t = normalize2dData(zspatialTRAIN_t);
    zspatialTRAIN_nt = normalize2dData(zspatialTRAIN_nt);
    end
end