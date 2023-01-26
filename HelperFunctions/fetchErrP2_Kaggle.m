function [Xtrain, Ytrain, Xtest, Ytest, fczcz, channelnames] = fetchErrP2_Kaggle(ddir, pno, car, lf, hf, fs, tstart, tend)

fczcz = [20 29]; %Fcz Cz
load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s \n",p_id);  

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Ytrain= ses1_label;
Ytest= ses2_label;
Xtrain=ses1_errp(:,:,:);
Xtest=ses2_errp(:,:,:);


end