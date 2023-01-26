% Mine Yasemin 2021
% load BNCI data and save as  subject*.mat files	

% http://bnci-horizon-2020.eu/database/data-sets  
% 22. Monitoring error-related potentials (013-2015)
% 6 participants
% 64 channels

clear;
participant = [ "S01" "S02" "S03" "S04" "S05" "S06"];       
plotfig=1; %option for plotting figures
channelnames = [ "Fp1" "AF7" "AF3" "F1" "F3" "F5" "F7" "FT7" "FC5" "FC3" "FC1" "C1" "C3"...
  "C5" "T7" "TP7" "CP5" "CP3" "CP1" "P1" "P3" "P5" "P7" "P9" "PO7" "PO3"...
  "O1" "Iz" "Oz" "POz" "Pz" "CPz" "Fpz" "Fp2" "AF8" "AF4" "AFz" "Fz" "F2"  ...
 "F4" "F6" "F8" "FT8" "FC6" "FC4" "FC2" "FCz" "Cz" "C2" "C4" "C6" "T8" ...
 "TP8" "CP6" "CP4" "CP2" "P2" "P4" "P6" "P8" "P10" "PO8" "PO4" "O2" ];
ses1_errp_all = [];
ses1_label_all = [];
%channelsidx=[10 11 12 13 18 19 32 38 45 46 47 48 49 50 55 56]; %16 selected channels
channelsidx= 1:64; %all channels
for pno=1:6
p_id=participant(pno);
fprintf ('Subject %s \n',p_id);
cn=length(channelsidx);
car=1;
lf=1;
hf=10;
ses1_errp = [];
ses1_label = [];
ses2_errp = [];
ses2_label = [];
N_tst1 = [];
N_tst2 = [];
% Read dataset session 1
load (strcat('D:\ErrPDatasets\BNCI Moving Cursor\rawdata\Subject0', num2str(pno), '_s1.mat'));
fprintf ('Day 1 sessions \n');
for r = 1:size(run,2)
    fprintf ('Extracting epochs from session %d \n',r);
    s = run{1, r};
    y_sel = s.eeg(:,channelsidx);
	events= s.header.EVENT.TYP;
	latencies = s.header.EVENT.POS;  
    fs= s.header.SampleRate;
    beforefb = 0.2*fs;
    
    y_sel = car_bpfilter(y_sel',car,cn,fs,lf,hf);
    j=1;
    label = [];
    errp1 = [];
    for i = 1:size(events,1)
        if events(i,1) == 5 || events(i,1) == 10 %correct
            tw=round(latencies(i)-beforefb: latencies(i)+fs-1);
            errp1(:,:,j) = y_sel(:,tw);
            label(1,j) = 2;
            j=j+1;
        elseif events(i,1) == 6 || events(i,1) == 9 %errors
            tw=round(latencies(i)-beforefb: latencies(i)+fs-1);
            errp1(:,:,j) = y_sel(:,tw);
            label(1,j) = 1;	
            j=j+1;
        end  
    end        
    ses1_errp = cat(3,ses1_errp, errp1);
     ses1_label = [ses1_label label];
    N_tst1 = [N_tst1 size(label,2)];       
            
end

ses1_errp_all = cat(3,ses1_errp_all, ses1_errp);
ses1_label_all = [ses1_label_all ses1_label];

 % Plot ErrP
Ts=1/fs;
t=-0.2+Ts:Ts:1;  
errp_er1=mean(ses1_errp(:,:,ses1_label==1),3);
errp_cr1=mean(ses1_errp(:,:,ses1_label==2),3);

% Fz - 38
figure; hold on; plot(t,errp_cr1(38,:),'k','linewidth',3) 
plot(t,errp_er1(38,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('channel Fz (average of all sessions)','fontweight','bold')

%% Read dataset session 2
load (strcat('D:\ErrPDatasets\BNCI Moving Cursor\rawdata\Subject0', num2str(pno), '_s2.mat'));
fprintf ('Day 2 sessions \n');
for r = 1:size(run,2)
    fprintf ('Extracting epochs from session %d \n',r);
    s = run{1, r};
    y_sel = s.eeg(:,channelsidx);
	events= s.header.EVENT.TYP;
	latencies = s.header.EVENT.POS;  
    fs= s.header.SampleRate;
    y_sel = car_bpfilter(y_sel',car,cn,fs,lf,hf);
    j=1;
    label = [];
    errp1 = [];
    for i = 1:size(events,1)
        if events(i,1) == 5 || events(i,1) == 10 %correct
           tw=round(latencies(i)-beforefb: latencies(i)+fs-1);
           errp1(:,:,j) = y_sel(:,tw);
            label(1,j) = 2;
            j=j+1;
        elseif events(i,1) == 6 || events(i,1) == 9 %errors
           tw=round(latencies(i)-beforefb: latencies(i)+fs-1);
           errp1(:,:,j) = y_sel(:,tw);
            label(1,j) = 1;	
            j=j+1;
        end  
    end        
    ses2_errp = cat(3,ses2_errp, errp1);
     ses2_label = [ses2_label label];
    N_tst2 = [N_tst2 size(label,2)];       
            
end

 % Plot ErrP
Ts=1/fs;
t=-0.2+Ts:Ts:1;  
errp_er2=mean(ses2_errp(:,:,ses2_label==1),3);
errp_cr2=mean(ses2_errp(:,:,ses2_label==2),3);

% Fz - 38
figure; hold on; plot(t,errp_cr2(38,:),'k','linewidth',3) 
plot(t,errp_er2(38,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('channel Fz (average of all sessions)','fontweight','bold')           

save(['D:\ErrPDatasets\BNCI Moving Cursor\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(pno)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1', 'ses2_errp', 'ses2_label', 'N_tst2');

end               

Ts=1/fs;
t=-0.2+Ts:Ts:1;  
errp_er1_all=mean(ses1_errp_all(:,:,ses1_label_all==1),3);
errp_cr1_all=mean(ses1_errp_all(:,:,ses1_label_all==2),3);

 if plotfig==1 % Plot average of sessions
% Fz - 38
figure; hold on; plot(t,errp_cr1_all(38,:),'k','linewidth',3) 
plot(t,errp_er1_all(38,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('channel Fz (average of all sessions)','fontweight','bold')   
 end