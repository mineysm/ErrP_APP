function [Xtrain, visual, N_tst, fczcz, fzczpz] = fetchErrP6_GameAgent(datadir, p_id, prefilt, car, lf, hf, fs, tstart, tend)
 if prefilt ==1 
    ddir = strcat(datadir,'/CFS');
 elseif prefilt ==2
    ddir = strcat(datadir,'/SNF');
 end
 fczcz = [1 2]; %Fz Cz
 fzczpz = [1 2 4];
if car==0
            if lf==0.1
                fprintf("NoCAR + 0.1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP0.1-10/ErrpGameAgent.mat'));
            else
                fprintf("NoCAR + 1 - 10 Hz \n");
                load(strcat(ddir,'/CAR0_BP1-10/ErrpGameAgent.mat'));
            end
        elseif car==1
            if lf==0.1
                fprintf("CAR + 0.1 - 10 Hz \n");
               load(strcat(ddir,'/CAR1_BP0.1-10/ErrpGameAgent.mat'));
            else
                fprintf("CAR + 1 - 10 Hz \n");
                load(strcat(ddir,'/CAR1_BP1-10/ErrpGameAgent.mat'));
            end
end

fprintf("Subject %s\n",ErrpGameAgent(1,p_id).sid);  
fprintf("---------------\n");
ytarget_cne = ErrpGameAgent(1,p_id).ytarget_cne;
visual = ErrpGameAgent(1,p_id).visual;
N_tst = ErrpGameAgent(1,p_id).N_tst;


%twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Xtrain = ytarget_cne(:, :, :); 


end
