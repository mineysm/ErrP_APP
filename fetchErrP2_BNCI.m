function [Xtrain, Ytrain, Xtest, Ytest, fczcz, fzczpz] = fetchErrP2_BNCI(datadir, pno, prefilt, car, lf, hf, fs, tstart, tend)
 fprintf("Subject %d \n",pno);  
  if prefilt ==1 
    ddir = strcat(datadir,'/CFS');
 elseif prefilt ==2
    ddir = strcat(datadir,'/SNF');
 end
 fczcz = [47 48];
 fzczpz = [38 48 31];
if car==0
    if lf==0.1
        fprintf("NoCAR + 0.1 - 10 Hz \n");
        load(strcat(ddir,'/CAR0_BP0.1-10/subject',num2str(pno),'.mat'));
    else
        fprintf("NoCAR + 1 - 10 Hz \n");
        load(strcat(ddir,'/CAR0_BP1-10/subject',num2str(pno),'.mat'));
    end
elseif car==1
    if lf==0.1
        fprintf("CAR + 0.1 - 10 Hz \n");
        load(strcat(ddir,'/CAR1_BP0.1-10/subject',num2str(pno),'.mat'));
    else
        fprintf("CAR + 1 - 10 Hz \n");
        load(strcat(ddir,'/CAR1_BP1-10/subject',num2str(pno),'.mat'));
    end
end

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Ytrain= ses1_label;
Ytest= ses2_label;
if prefilt==1
    Xtrain=ses1_errp(:,:,:);
    Xtest=ses2_errp(:,:,:);
else
    Xtrain=ses1_errp_filt(:,:,:);
    Xtest=ses2_errp_filt(:,:,:);
end

end