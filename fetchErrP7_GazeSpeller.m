function [Xtrain, Ytrain, N_tst, fczcz, fzczpz] = fetchErrP7_GazeSpeller(datadir, p_no, prefilt, car, lf, hf, fs, tstart, tend)
participant = [1 2 3 4 5 6 7 11 13 15];
pno= participant(p_no);
 fczcz = [57 58];
 fzczpz = [56 58 60];
 N_tst = 0;
 fprintf("Subject %d \n",pno);  
 if prefilt ==1 
    ddir = strcat(datadir,'/trials');
    load(strcat(ddir,'/subject',num2str(pno),'.mat'));
 elseif prefilt ==2
    ddir = strcat(datadir,'/SNF');
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
 end

%twin = round((tstart+0.2)*fs)+1:round((tstart+tend+0.2)*fs);
Ytrain= ses1_label;

if prefilt==1
    Xtrain=ses1_errp(:,:,:);
else
    Xtrain=ses1_errp_filt(:,:,:);
end


end
