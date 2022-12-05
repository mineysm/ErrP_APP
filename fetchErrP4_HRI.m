function [Xtrain, visual, N_tst, fczcz, fzczpz] = fetchErrP4_HRI(datadir, p_id, prefilt, car, lf, hf, expno, fs,  tstart, tend )

 if prefilt ==1 
    ddir = strcat(datadir,'/CFS');
 elseif prefilt ==2
    ddir = strcat(datadir,'/SNF');
 end
 fczcz = [2 20]; %Fz Cz
  fzczpz = [2 20 11]; %Fz Cz Pz
   if expno==1
        if car==0
            if lf==0.1
                fprintf("0.1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP0.1-10/ErrpHRIcursor.mat'));
            else
                fprintf("1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP1-10/ErrpHRIcursor.mat'));
             %load(strcat(datadir,'/NoCAR_gpBP1-10/subject',num2str(pno),'.mat'));
            end
        elseif car==1
            if lf==0.1
                fprintf("CAR + 0.1 - 10 Hz \n");
               load(strcat(ddir,'/CAR1_BP0.1-10/ErrpHRIcursor.mat'));
            else
                fprintf("CAR + 1 - 10 Hz \n");
                load(strcat(ddir,'/CAR1_BP1-10/ErrpHRIcursor.mat'));
            end
        end
   else  %robot scenario
       if car==0
            if lf==0.1
                fprintf("0.1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP0.1-10/ErrpHRIrobot.mat'));
            else
                fprintf("1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP1-10/ErrpHRIrobot.mat'));
             %load(strcat(datadir,'/NoCAR_gpBP1-10/subject',num2str(pno),'.mat'));
            end
        elseif car==1
            if lf==0.1
                fprintf("CAR + 0.1 - 10 Hz \n");
               load(strcat(ddir,'/CAR1_BP0.1-10/ErrpHRIrobot.mat'));
            else
                fprintf("CAR + 1 - 10 Hz \n");
                load(strcat(ddir,'/CAR1_BP1-10/ErrpHRIrobot.mat'));
            end
        end
   end

fprintf("Subject %s\n",ErrpHRI(1,p_id).sid);  
fprintf("---------------\n");
ytarget_cne = ErrpHRI(1,p_id).ytarget_cne;
visual = ErrpHRI(1,p_id).visual;
N_tst = ErrpHRI(1,p_id).N_tst;


 twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
 Xtrain = ytarget_cne(:, :, :); 

end