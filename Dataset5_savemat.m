%Mine Yasemin August 2021
%load Coadaptation data and save as subject*.mat files
% https://github.com/stefan-ehrlich/dataset-ErrP-coadaptation
clear;
car=0; %common average reference
lf=1; %lower freq.
hf=10; %higher freq.
sessionno = [1 2 4];
participant = [3 4 6 7 8 9 11 12 14 15 16 17 18]; %  [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
plotfig=1; %option for plotting figures
Fold=1;
fdtime=1;  % event duration after feedback (max. 1.5 s)
beforefdb = 0.2; % max 0.5 s

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
fc=[0.5 20]; % 
ses1_label=[];ses2_label=[];

%Calibration session
if p_id<10
EEG=pop_loadset(['D:\ErrPDatasets\Coadaptation\data_coadaptation\s0',num2str(p_id),'\s0',num2str(p_id),'_calib.set']);
else 
EEG=pop_loadset(['D:\ErrPDatasets\Coadaptation\data_coadaptation\s',num2str(p_id),'\s',num2str(p_id),'_calib.set']);
end
[ses1_errp, ses1_label, ~]= preprocessdata(EEG, chind, fc, beforefdb, fdtime, 150, car, lf, hf);
N_tst1 = length(ses1_label);

%Co-adaptation sessions
for jj= 1: length(sessionno)
    if p_id<10
    EEG2=pop_loadset(['D:\ErrPDatasets\Coadaptation\data_coadaptation\s0',num2str(p_id),'\s0',num2str(p_id),'_corl',num2str(sessionno(jj)),'.set']);
    else
    EEG2=pop_loadset(['D:\ErrPDatasets\Coadaptation\data_coadaptation\s',num2str(p_id),'\s',num2str(p_id),'_corl',num2str(sessionno(jj)),'.set']);
    end
    [y_cne, vis, twin]= preprocessdata(EEG2, chind, fc, beforefdb, fdtime, 50,car, lf, hf);
    
    N_tst2(jj,1) = length(vis);
    ses2_label=[ses2_label vis];
    
    if jj==1
    ses2_errp = y_cne;
    else
    ses2_errp = cat(3, ses2_errp, y_cne);
    end
    
    clear EEG2 y_cne vis
end    

save(['D:\ErrPDatasets\Coadaptation\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p)], 'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1', 'ses2_errp', 'ses2_label', 'N_tst2');


if plotfig==1 % Plot all channels

tidx1 = find(ses2_label==1);
tidx2 = find(ses2_label==2);
ztarget= ses2_errp(:,:,tidx1);
zNONtarget= ses2_errp(:,:,tidx2);

C1_t=mean(ztarget,3);
C1_nt=mean(zNONtarget,3);
figure;
subplot 211
for ch=1:size(C1_t,1) 
 h1=  plot(twin,C1_t(ch,:),'b');
    hold on
end
for ch=1:size(C1_nt,1) 
  h2=  plot(twin,C1_nt(ch,:),'r');
end
hold off
axis tight
title('Trial averaged data - Cz' ); %all channels');
legend([h1(1), h2(1)], 'error', ' correct')
xlabel('time')
ylabel('amplitude')

for ch = 1 : size(ses2_errp,1)
    for sample = 1 : size(ses2_errp,2)
        ressq_all(sample,ch) = rsquare(ses2_errp(ch, sample, find(ses2_label==1)), ses2_errp(ch, sample, find(ses2_label==2)));
    end
end
subplot 212
plot_rsquare(twin, ressq_all)
axis normal

end
end

function [y_cne, vis, twin] = preprocessdata(EEG, chind, fc, beforefdb, fdtime, nepochs, car,lf,hf)

fs=EEG.srate;
%eeg_eventtypes(EEG);
% 33025 NAO decision – left object (not communicated to subject)
% 33026 NAO decision – middle object (not communicated to subject)
% 33027 NAO decision – right object (not communicated to subject)
% 33028 Human decision left object (response key “1”)
% 33029 Human decision middle object (response key “2”)
% 33030 Human decision right object (response key “3”)
% 33031 Feedback no error
% 33033 Feedback machine/human error
% 33034 NAO communicates chosen object via flashing LED
% 33035 NAO communicates chosen object via speaking out the name of the object
% 33036 NAO turns to object of interest
% 33037 NAO turns to other 1. object
% 33038 NAO turns to other 2. object
% 33039 NAO turns to human
cn=length(chind);
EEG.chanlocs  = EEG.chanlocs(1,chind);
EEG.data = car_bpfilter(EEG.data(chind,:),car,cn,fs,lf,hf);

%Pre-processing steps in the paper
% 1) causal first-order Butterworth FIR bandpass filter with cutoff frequencies 0.5 and 20 Hz
%[b, a] = butter(1, fc/(fs/2));
%EEG.data = filter(b, a, EEG.data);
%or
%EEG = pop_eegfiltnew(EEG, 0.5, 20);
% 2) EOG activity (horizontal and vertical) was reduced in the data by using a regression method
%[EEG] = pop_lms_regression(EEG, [5 16 25] , 3, 1e-06, []);
% 3) the data re-referenced to common average
%EEG = pop_reref( EEG, [], 'exclude', [5 16 25] );

% 4) All data segments were then normalized by subtracting their individual means for each channel/segment

% Here we should have EEG data matrix as 30*512*500 (channel*time*trial)
% S5 epochs will be discarded.
[EEG, ~] = pop_epoch(EEG,{33031, 33033},[-1*beforefdb fdtime],...
'newname','feedback epochs',...
'epochinfo','yes');
%EEG = pop_rmbase(EEG,[]);

%%
%for jj=1:Fold
%fprintf("Fold %d\n",jj);    
%allchannels = {'Fp1';'Fz';'F3';'F7';'EOG1';'FC5';'FC1';'C3';'T7';'CP5';'CP1';'Pz';'P3';'P7';'O1';'EOG3';'O2';'P4';'P8';'CP6';'CP2';'Cz';'C4';'T8';'EOG2';'FC6';'FC2';'F4';'F8';'Fp2'};
%eegchannels = {'Fp1';'Fz';'F3';'F7';'FC5';'FC1';'C3';'T7';'CP5';'CP1';'Pz';'P3';'P7';'O1';'O2';'P4';'P8';'CP6';'CP2';'Cz';'C4';'T8';'FC6';'FC2';'F4';'F8';'Fp2'};

%EEG1=pop_selectevent(EEG, 'epoch',(50*(jj-1)+1:jj*50), 'deleteevents', ...
%'off','deleteepochs','on');
  fun1 = @(x) EEG.event(1,x).type ==  33031;  
  fun2 = @(x) EEG.event(1,x).type ==  33033;
  tf1 = arrayfun(fun1, 1:numel(EEG.event(1,:)));
  tf2 = arrayfun(fun2, 1:numel(EEG.event(1,:)));
  index1 = find(tf1);  % correct epochs
  index2 = find(tf2);  % error epochs
  noftrials= length(index1)+length(index2);
  
if noftrials==nepochs
EEGcor=pop_selectevent(EEG,'type',33031, 'deleteevents', ...
'off','deleteepochs','on');

EEGerr=pop_selectevent(EEG,'type',33033, 'deleteevents', ...
'off','deleteepochs','on');
end

Xtrain = cat(3, EEGerr.data,  EEGcor.data); 
Ytrain = [zeros(1,size(EEGerr.data,3)) ones(1,size(EEGcor.data,3))];
Ytrain = Ytrain +1;
randId = randperm(length(Ytrain));

tpoints = EEGerr.times;
FBstarttime = beforefdb*fs;
win = (FBstarttime+1-beforefdb*fs):(FBstarttime+fdtime*fs);
twin = tpoints(win);

y_cne = Xtrain(:, win, randId); 
y_cne= double(y_cne);
vis = Ytrain(randId);

end