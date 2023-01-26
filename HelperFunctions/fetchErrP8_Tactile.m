function [Xtrain, Ytrain, N_tst, fczcz, channelnames] = fetchErrP8_Tactile(ddir, pno, car, lf, hf, fs, tstart, tend)

fczcz = [4 9];
N_tst = 0;
load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s \n",num2str(p_id));  
twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain=ses1_errp(:,:,:);
Ytrain= ses1_label;
    
    
end
