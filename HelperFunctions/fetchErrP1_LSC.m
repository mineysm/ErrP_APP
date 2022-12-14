function [Xtrain, Ytrain, Xtest, Ytest, fczcz, fzczpz] = fetchErrP1_LSC(ddir, pno, car, lf, hf, fs, tstart, tend)

participant = ["P1" "S1" "S2" "S3" "S4" "S5" "S6" "S9"];        
fprintf("Subject: %s \n",participant(pno));  
fczcz = [1 2];
fzczpz = [1 2 6];

load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Ytrain= ses1_label;
Ytest= ses2_label;

Xtrain=ses1_errp(:,:,:);
Xtest=ses2_errp(:,:,:);


end



