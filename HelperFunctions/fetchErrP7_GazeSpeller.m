function [Xtrain, Ytrain, N_tst, fczcz, channelnames] = fetchErrP7_GazeSpeller(ddir, pno, car, lf, hf, fs, tstart, tend)

fczcz = [57 58];
N_tst = 0;
load(strcat(ddir,'/trials/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s\n",p_id);   
twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain=ses1_errp(:,:,:);
Ytrain= ses1_label;



end
