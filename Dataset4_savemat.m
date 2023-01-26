% %Mine Yasemin August 2021
%load HRI data and save as subject*.mat files	
% https://github.com/stefan-ehrlich/dataset-ErrP-HRI
clear;
car=0; %common average reference
lf=1; %lower freq.
hf=10; %higher freq.
fs = 256;
expno=1; % 1-> cursor scenario, 2-> robot scenario
participant = [2 3 4 5 6 7 8 9 10 11 13];
plotfig=1; %option for plotting figures
Fold=10; %10 blocks 
fdtime=1.2;  % event duration after feedback (max. 1.5 s)
beforefdb = 0.2; % max 0.5 s
ses1_errp_all = [];
ses1_label_all = [];

allchannels = ["Fp1" "Fz" "F3" "F7" "EOG1" "FC5" "FC1" "C3" "T7" "CP5" "CP1" "Pz" "P3" "P7" ...
    "O1" "EOG3" "O2" "P4" "P8" "CP6" "CP2" "Cz" "C4" "T8" "EOG2" "FC6" "FC2" "F4" "F8" "Fp2"];
chEEG = [1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1]; % 1 for EEG, 0 for EOG channels
chind = find(chEEG==1);
%chind=[2 3 6 7 8 10 11 13 18 20 21 22 23 26 27 28]; %16 selected channels
channelnames = allchannels(chEEG==1);

for p=1:length(participant)
    p_id=participant(p);
    fprintf("Participant %d\n",p_id);  
    fprintf("---------------\n");
    fc=[1 20]; % 
    visual=[];
    cn=length(chind);
    
    if expno==1 
        if p_id<10
        EEG=pop_loadset(['D:\ErrPDatasets\HRI (cursor)\cursor\s0',num2str(p_id),'_cursor.set']);
        else 
        EEG=pop_loadset(['D:\ErrPDatasets\HRI (cursor)\cursor\s',num2str(p_id),'_cursor.set']);
        end
    else
        if p_id<10
        EEG=pop_loadset(['D:\ErrPDatasets\HRI (robot)\robot\s0',num2str(p_id),'_robot.set']);
        else
        EEG=pop_loadset(['D:\ErrPDatasets\HRI (robot)\robot\s',num2str(p_id),'_robot.set']);
        end
    end
    
    fs=EEG.srate;
    %eeg_eventtypes(EEG);
    % empty    
    % S1 Presentation of stimulus � left
    % S2 Presentation of stimulus � up
    % S3 Presentation of stimulus � right
    % R1 Response arrow key � left
    % R2 Response arrow key � up
    % R3 Response arrow key � right
    % S4 Feedback no error
    % S5 Feedback human error
    % S6 Feedback machine error
    % FB1 Feedback left
    % FB2 Feedback up
    % FB3 Feedback right
    % S7 Appearance of feedback (color-frame)
    % S8 Start robot head moving back
    % S9 End of trial
    
    EEG.data = car_bpfilter(EEG.data(chind,:),car,cn,fs,lf,hf);
    
    %Pre-processing steps in the paper
    % 1) a zero phase Hamming windowed sinc FIR band-pass filter with cutoff frequencies of 1 Hz and 20 Hz
    %%%%EEG = pop_eegfiltnew(EEG, 1, 20);
    % 2) contaminated EEG channels identified and interpolated using kurtosis with a threshold of 5%
    % 3) EOG activity in the EEG signals was corrected
    % 4) the EEG signals re-referenced to common average (CAR)
    %%%%EEG = pop_reref( EEG, [], 'exclude', [5 16 25] );
    
    % Here we should have EEG data matrix as 30*512*500 (channel*time*trial)
    % S5 epochs will be discarded.
    [EEG, indices] = pop_epoch(EEG,{'S  4' 'S  5' 'S  6'},[-1*beforefdb fdtime],...
    'newname','feedback epochs',...
    'epochinfo','yes');
    %EEG = pop_rmbase(EEG,[-200 0]);
    
    
    %%
    for jj=1:Fold
        fprintf("Fold %d\n",jj);    
        
        EEG1=pop_selectevent(EEG, 'epoch',(50*(jj-1)+1:jj*50), 'deleteevents', ...
        'off','deleteepochs','on');
          fun1 = @(x) EEG1.event(1,x).type ==  "S  4";  
          fun2 = @(x) EEG1.event(1,x).type ==  "S  6";
          fun3 = @(x) EEG1.event(1,x).type ==  "S  5";
          tf1 = arrayfun(fun1, 1:numel(EEG1.event(1,:)));
          tf2 = arrayfun(fun2, 1:numel(EEG1.event(1,:)));
          tf3 = arrayfun(fun3, 1:numel(EEG1.event(1,:)));
          index1 = find(tf1);  % correct epochs
          index2 = find(tf2);  % error epochs
          index3 = find(tf3);  % human error epochs  % discarded
          noftrials = length(index1)+length(index2)+length(index3) %must be 50
          if noftrials==50
            EEGcor=pop_selectevent(EEG1,'type',{'S  4'}, 'deleteevents', ...
            'off','deleteepochs','on');
        
            EEGerr=pop_selectevent(EEG1,'type',{'S  6'}, 'deleteevents', ...
            'off','deleteepochs','on');
          end
          
        Xtrain = cat(3, EEGerr.data,  EEGcor.data); % S2 cursor -> 30*512*484
        Ytrain = [zeros(1,size(EEGerr.data,3)) ones(1,size(EEGcor.data,3))];
        Ytrain = Ytrain +1; % 1-> error, 2-> correct
        randId = randperm(length(Ytrain));
        
        tpoints = EEGerr.times;
        FBstarttime = 0;
        twin = (FBstarttime+1-beforefdb*fs):(FBstarttime+fdtime*fs);
        
        y_cne = Xtrain(:, :, randId); 
        vis = Ytrain(randId);
        
        N_tst(jj,1) = length(vis);
        visual=[visual vis];
        
        if jj==1
            ytarget_cne = y_cne;
        else
            ytarget_cne = cat(3, ytarget_cne, y_cne);
        end
        
        clear EEG1 EEGcor EEGerr y_cne
    end
    
if expno==1
save(['D:\ErrPDatasets\HRI (cursor)\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p)],'p_id','channelnames', 'ytarget_cne', 'visual', 'N_tst');
else
save(['D:\ErrPDatasets\HRI (robot)\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p)],'p_id','channelnames', 'ytarget_cne', 'visual', 'N_tst');
end
    %%
    if plotfig==1 % Plot all channels
    tidx1 = find(visual==1);
    tidx2 = find(visual==2);
    
    ztarget= ytarget_cne(:,:,tidx1);
    zNONtarget= ytarget_cne(:,:,tidx2);
        
    C1_t=mean(ztarget,3);
    C1_nt=mean(zNONtarget,3);
    figure;
    subplot 211
    for ch=20%1:chn 
        plot(tpoints,C1_t(ch,:),'b');
        hold on
    end
    for ch=20%1:chn
        plot(tpoints,C1_nt(ch,:),'r');
    end
    hold off
    axis tight
    title('Trial averaged data - Cz' ); %all channels');
    legend('Error','Nonerror')
    xlabel('time')
    ylabel('amplitude')
    
    
    for ch = 1 : size(ytarget_cne,1)
        for sample = 1 : size(ytarget_cne,2)
            ressq_all(sample,ch) = rsquare(ytarget_cne(ch, sample, find(visual==1)), ytarget_cne(ch, sample, find(visual==2)));
        end
    end
    subplot 212
    plot_rsquare(tpoints/1000, ressq_all)
    axis normal
    end
    
    
    ses1_errp_all = cat(3,ses1_errp_all, ytarget_cne);
    ses1_label_all = [ses1_label_all visual];
end

 % Plot ErrP - average of all subjects
Ts=1/fs;
t=-0.2+Ts:Ts:1.2;  
errp_er1=mean(ses1_errp_all(:,:,ses1_label_all==1),3);
errp_cr1=mean(ses1_errp_all(:,:,ses1_label_all==2),3);

% Fz - 2
figure; hold on; plot(t,errp_cr1(2,:),'k','linewidth',3) 
plot(t,errp_er1(2,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('channel Fz (average of all subjects)','fontweight','bold')




