function [Xtrain, Ytrain, Xtest, Ytest, fczcz, fzczpz] = fetchErrP5_Coadaptation(datadir, p_id, prefilt, car, lf, hf, fs, tstart, tend)
 if prefilt ==1 
    ddir = strcat(datadir,'/CFS');
 elseif prefilt ==2
    ddir = strcat(datadir,'/SNF');
 end
 fczcz = [2 20]; %Fz Cz
 fzczpz = [2 20 11]; %Fz Cz Pz
        if car==0
            if lf==0.1
                fprintf("0.1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP0.1-10/ErrpCalibration.mat'));
                load(strcat(ddir,'/CAR0_BP0.1-10/ErrpCoadaptation.mat'));
            else
                fprintf("1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP1-10/ErrpCalibration.mat'));
                load(strcat(ddir,'/CAR0_BP1-10/ErrpCoadaptation.mat'));
            end
        elseif car==1
            if lf==0.1
                fprintf("CAR + 0.1 - 10 Hz \n");
               load(strcat(ddir,'/CAR1_BP0.1-10/ErrpCalibration.mat'));
               load(strcat(ddir,'/CAR1_BP0.1-10/ErrpCoadaptation.mat'));
            else
                fprintf("CAR + 1 - 10 Hz \n");
                load(strcat(ddir,'/CAR1_BP1-10/ErrpCalibration.mat'));
                load(strcat(ddir,'/CAR1_BP1-10/ErrpCoadaptation.mat'));
            end
        end

s_id = ErrpCALIB(1,p_id).sid;
fprintf("Subject %s\n",s_id);  
fprintf("---------------\n");
X1 = ErrpCALIB(1,p_id).ytarget_cne;
Ytrain = ErrpCALIB(1,p_id).visual;
N_train = ErrpCALIB(1,p_id).N_tst;

X2 = ErrpCORL(1,p_id).ytarget_cne;
Ytest = ErrpCORL(1,p_id).visual;
N_test = ErrpCORL(1,p_id).N_tst;


% FBstarttime = 0.2; %the time interval 200 ms before feedback
% twin = round((FBstarttime)*fs+1:(FBstarttime+fdtime)*fs);

  twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain = X1(:, :, :); 
Xtest = X2(:, :, :); 

end
