function [Xtrain, Ytrain, Xtest, Ytest, fczcz, channelnames] = fetchErrP3_LSC(ddir, pno, car, lf, hf, fs, tstart, tend)

fczcz = [1 2];
load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s \n",p_id);  

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Ytrain= ses1_label;
Ytest= ses2_label;
Xtrain=ses1_errp(:,:,:);
Xtest=ses2_errp(:,:,:);


end



