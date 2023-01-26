function [Xtrain, Ytrain, Xtest, Ytest, fczcz, channelnames] = fetchErrP5_Coadaptation(ddir, pno, car, lf, hf, fs, tstart, tend)

fczcz = [2 20]; %Fz Cz    
load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s \n",num2str(p_id));  

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain=ses1_errp(:,:,:);
Xtest=ses2_errp(:,:,:);
Ytrain= ses1_label;
Ytest= ses2_label;

end
