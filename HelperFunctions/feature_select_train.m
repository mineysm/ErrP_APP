function [modelo_T, modelo_nonT, win, X, clabel, Point3 ] =  feature_select_train(zspatialTRAIN_t,zspatialTRAIN_nt, featsel, feat_method, nf)
                    
                    if featsel ==1 && feat_method==1
                        if nf>size(zspatialTRAIN_t,2)
                        fprintf("Number of features is smaller for feature selection.. \n");
                        end
                        [Point3]=feature_selection(zspatialTRAIN_t,zspatialTRAIN_nt, feat_method,nf); 
                        [zspatialTRAIN_selt]=ac_ErrP_feature(zspatialTRAIN_t,Point3,1); 
                        [zspatialTRAIN_selnt]=ac_ErrP_feature(zspatialTRAIN_nt,Point3,1);
                         fprintf("%d features selected by Rsquare method.. \n",nf);
                    elseif featsel ==1 && feat_method==2
                        if nf>size(zspatialTRAIN_t,2)
                        fprintf("Number of features is smaller for feature selection.. \n");
                        end
                           [~, Point3]=feature_selection(zspatialTRAIN_t,zspatialTRAIN_nt, 2,nf); 
                        [zspatialTRAIN_selt]=ac_ErrP_feature(zspatialTRAIN_t,Point3,1); 
                        [zspatialTRAIN_selnt]=ac_ErrP_feature(zspatialTRAIN_nt,Point3,1);
                         fprintf("%d features selected by PCA method.. \n",nf);
                    elseif featsel ==0
                        Point3 = [];
                        zspatialTRAIN_selt = zspatialTRAIN_t;
                        zspatialTRAIN_selnt = zspatialTRAIN_nt;
                    end
                modelo_T=zspatialTRAIN_selt(:,:)';
                modelo_nonT=zspatialTRAIN_selnt(:,:)';
                win=1:size(zspatialTRAIN_selnt,2);  
                X = [modelo_T modelo_nonT]';
                clabel = [ones(size(modelo_T,2),1); ones(size(modelo_nonT,2),1)+1]';

end