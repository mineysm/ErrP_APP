%Mine Yasemin August 2021
%load LSC data and save as  subject*.mat files	
% https://ieee-dataport.org/open-access/error-related-potentials-primary-and-secondary-errp-and-p300-event-related-potentials-%E2%80%93
% Fz, Cz, C3, C4, CPz, Pz, P3, P4, PO7, PO8, POz and Oz 
clear
datadir=  "D:\ErrPDatasets\LSC Speller";
ses1_errp_all = [];
ses1_label_all = [];
ses2_errp_all = [];
ses2_label_all = [];
for pno=1:8
fprintf ('Subject %d \n',pno);
car=0;
cn=12;
fs=256;
lf=1;
hf=10;
participant = ["P1" "S1" "S2" "S3" "S4" "S5" "S6" "S9"];                   
ses1 = [6 6 10 12 6 7 7 10];
ses2 = [4 4 4 5 5 4 5 5];
Ts=1/fs;
t=-0.2:Ts:1-Ts;  
ses1_errp = [];
ses1_label = [];

ses2_errp = [];
ses2_label = [];

N_tst1 = [];
N_tst2 = [];
%session 1
for j=1:ses1(pno)
    fprintf ('Extracting epochs from session %d \n',j);
        signal(j)=load(strcat(datadir,'/ErrP_Training_Session1/',participant(pno),'_Sess1_sentence',num2str(j),'.mat')); 
         label_1st_fbck=ac_ErrP_Label(signal(j).eeg,1);
         ses1_label = [ses1_label label_1st_fbck];
         y_sel=signal(j).eeg(2:13,:); 
         %y_sel = car_bpfilter(y_sel,car,cn,fs,lf,hf);
         y_sel=gp_lowpass_filtro_matrix(y_sel,[lf hf],4,fs);   
         [errp1, ~]=ac_ErrP_data(y_sel,signal(j).eeg, 0.2);
         ses1_errp = cat(3,ses1_errp, errp1);
         N_tst1 = [N_tst1 size(label_1st_fbck,2)];
end

ses1_errp_all = cat(3,ses1_errp_all, ses1_errp);
ses1_label_all = [ses1_label_all ses1_label];

%session 2
for j=1:ses2(pno)
        signal(j)=load(strcat(datadir,'/P300_ErrP_Test_Session2/',participant(pno),'_Sess2_sentence',num2str(j),'.mat')); 
        label_1st_fbck=ac_ErrP_Label(signal(j).eeg,1);
        ses2_label = [ses2_label label_1st_fbck];
         y_sel=signal(j).eeg(2:13,:); 
         %y_sel = car_bpfilter(y_sel,car,cn,fs,lf,hf);
         y_sel=gp_lowpass_filtro_matrix(y_sel,[lf hf],4,fs);   
         [errp2, ~]=ac_ErrP_data(y_sel,signal(j).eeg, 0.2);
         ses2_errp = cat(3,ses2_errp, errp2);
         N_tst2 = [N_tst2 size(label_1st_fbck,2)];
end
    
ses2_errp_all = cat(3,ses2_errp_all, ses2_errp);
ses2_label_all = [ses2_label_all ses2_label];

 %% Plot ErrP
errp_er1=mean(ses1_errp(:,:,ses1_label==1),3);
errp_cr1=mean(ses1_errp(:,:,ses1_label==2),3);


figure; hold on; plot(t,errp_cr1(1,:),'k','linewidth',3) % channel Fz 
plot(t,errp_er1(1,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('EEG Signal at channel Fz (average of all sessions)','fontweight','bold')           

            
%save(['C:\Users\bci\Desktop\ErrP_APP\ErrPDatasets\LSC Speller\CFS\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(pno)],'ses1_errp', 'ses1_label', 'N_tst1', 'ses2_errp', 'ses2_label', 'N_tst2');

end

errp_er1_all=mean(ses1_errp_all(:,:,ses1_label_all==1),3);
errp_cr1_all=mean(ses1_errp_all(:,:,ses1_label_all==2),3);

errp_er2_all=mean(ses2_errp_all(:,:,ses2_label_all==1),3);
errp_cr2_all=mean(ses2_errp_all(:,:,ses2_label_all==2),3);


figure; hold on; plot(t,errp_cr1_all(1,:),'k','linewidth',3) % channel Fz 
plot(t,errp_er1_all(1,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('EEG Signal at channel Fz (average of offline sessions)','fontweight','bold')           



figure; hold on; plot(t,errp_cr2_all(1,:),'k','linewidth',3) % channel Fz 
plot(t,errp_er2_all(1,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('EEG Signal at channel Fz (average of online sessions)','fontweight','bold')           


% P300
lar=270;
alt=150;
canal=5; %Cz 2, Pz 6 CPz 5 Fz 1
ld=3;
lt=5;
ls=8;
 
cr=find(ses1_label_all==2);
er=find(ses1_label_all==1);

errp_er1=er;
errp_cr1=cr;
errp_er11=mean(ses1_errp_all(:,:,errp_er1),3);
errp_cr11=mean(ses1_errp_all(:,:,errp_cr1),3);

std_dev = std(ses1_errp_all(:,:,errp_er1),[],3);
curve3 = errp_er11 + std_dev;
curve4 = errp_er11 - std_dev;
% t2 = [t, fliplr(t)];
area = [curve3, fliplr(curve4)];

std_dev = std(ses1_errp_all(:,:,errp_cr1),[],3);
curve3 = errp_cr11 + std_dev;
curve4 = errp_cr11 - std_dev;
t2 = [t, fliplr(t)];
area2 = [curve3, fliplr(curve4)];

figure;
hold on;
fill(t2, area(1,:), [.3 .3 .3], 'linestyle', 'none');
fill(t2, area2(1,:), [0.5 0.3 0.3], 'linestyle', 'none');
plot(t,errp_cr11(1,:),'k','linewidth',ld)
plot(t,errp_er11(1,:),'r','linewidth',ld)
h=legend('Correct letter','1º ErrP');
xlabel('time (s)','FontSize',ls)
ylabel('Amplitude (uV)','FontSize',ls)
title('EEG Signal at channel Fz','fontweight','bold')
set(gcf, 'Position', [500, 500, lar, alt])
set(gca,'ydir','normal'); 
set(h,'FontSize',lt,'fontweight','bold');
