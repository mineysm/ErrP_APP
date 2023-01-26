function [Xtrain, Ytrain, N_tst, fczcz, channelnames] = fetchErrP6_GameAgent(ddir, pno, car, lf, hf, fs, tstart, tend)
 
fczcz = [1 2]; %Fz Cz
load(strcat(ddir,'/CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'/subject',num2str(pno),'.mat'));
fprintf("Subject code: %s\n",p_id);  

twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain = ytarget_cne(:, :, :); 
Ytrain = visual;


end
