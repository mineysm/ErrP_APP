%Mine Yasemin August 2021
%load Kaggle data and save as .mat files	

% https://www.kaggle.com/competitions/inria-bci-challenge/data
clear;
plotfig=1; %option for plotting figures
set= [2 1 2 2 2 1 1 2 2 2 1 1 1 1 2 1 1 1 2 1 1 1 1 1 2 1];
participant = [ "S1" "S2" "S3" "S4" "S5" "S6" "S7" "S8" "S9" "S10" "S11" "S12" "S13" "S14" "S15" "S16" "S17" "S18" "S19" "S20" "S21" "S22" "S23" "S24" "S25" "S26" ];        
%training_subj=[2,6,7,11,12,13,14,16,17,18,20,21,22,23,24,26];  %training subjects
%test_subj=[1,3,4,5,8,9,10,15,19,25];  % test subjects
% channel labels
channelnames = [ "Fp1"	"Fp2"	"AF7"	"AF3"	"AF4"	"AF8"	"F7"	"F5"	"F3"	"F1"	"Fz"	"F2"	"F4"	"F6"	"F8"	"FT7"...
 "FC5"	"FC3"	"FC1"	"FCz"	"FC2"	"FC4"	"FC6"	"FT8"	"T7"	"C5"	"C3"	"C1"	"Cz"	"C2"	"C4"	"C6"	"T8"	...
 "TP7"	"CP5"	"CP3"	"CP1"	"CPz"	"CP2"	"CP4"	"CP6"	"TP8"	"P7"	"P5"	"P3"	"P1"	"Pz"	"P2"	"P4"	"P6"	...
 "P8"	"PO7"	"POz"	"P08"	"O1"	"O2" ];
% Fcz and Cz, 20 29
%channelsidx=[12 19 20 21 22 23 28 29 30 31 32 37 38 39 40 41]; %16 selected channels
channelsidx= 2:57;
cn=length(channelsidx);
car=0;
lf=1;
hf=10;
fs = 200;
fdt=1.3*fs; % feedback time
tbefore=0.2*fs;

 dir_info.data = "D:\ErrPDatasets\Kaggle P300 Speller\data\";

channel_locs_fname = fullfile(dir_info.data, 'ChannelsLocation.csv'); %set path
channel_locs = readtable(channel_locs_fname); 
chan_labels = {'Time', channel_locs.Labels{:},'EOG','FeedBackEvent'};

training_labels_fname = fullfile(dir_info.data, 'TrainLabels.csv'); %set path
training_labels = readtable(training_labels_fname); 

test_labels_fname = fullfile(dir_info.data,'true_labels.csv'); %set path
test_labels = readtable(test_labels_fname); 

p1=0; p2=0;          
for pno=1:26 % subject id
    p_id= participant(pno);
    ses1_errp = [];
    ses1_label = [];
    ses2_errp = [];
    ses2_label = [];
    N_tst1 = [];
    N_tst2 = [];
    fprintf ('Subject %d\n',pno);
     ind= [];
        for ses=1:5
            if pno<10
                if set(pno)==1
                data_path=strcat(dir_info.data,sprintf('train/Data_S0%d_Sess0%d.csv',pno,ses)); 
                else
                data_path=strcat(dir_info.data,sprintf('test/Data_S0%d_Sess0%d.csv',pno,ses));      
                end
            else
                if set(pno)==1
                data_path=strcat(dir_info.data,sprintf('train/Data_S%d_Sess0%d.csv',pno,ses)); 
                else
                data_path=strcat(dir_info.data,sprintf('test/Data_S%d_Sess0%d.csv',pno,ses));      
                end
            end
            fprintf('Reading data from %s \n',data_path);
            data=readtable(data_path);
             %  num of EEG channels 56, 
            y_sel=table2array(data(:,channelsidx));
            ind=find(data.FeedBackEvent==1);
             y_sel = car_bpfilter(y_sel',car,cn,fs,lf,hf);
             fprintf ('Extracting epochs from  subject %d session %d \n', pno,ses);	
              errp1 = [];
                for i=1:length(ind)        
                        errp1(:,:,i) = y_sel(:,ind(i)-tbefore:ind(i)+fdt-1);
                end
                if ses<5
                ses1_errp = cat(3,ses1_errp, errp1);
                N_tst1 = [N_tst1 size(errp1,3)];     
                else
                ses2_errp = cat(3,ses2_errp, errp1);
                N_tst2 = [N_tst2 size(errp1,3)];     
                end
        end

     if set(pno)==1
         label = table2array(training_labels(p1*340+1:(p1+1)*340,2));
         p1=p1+1;
     else
         label = table2array(test_labels(p2*340+1:(p2+1)*340,1));
         p2=p2+1;
     end
         label = label';
         ses1_label=label(1,1:240)+1;   % 0->1 error, 1->2 correct
         ses2_label=label(1,241:340)+1;
% Plot ErrP
Ts=1/fs;
t=-0.2+Ts:Ts:1.3;  
errp_er1=mean(ses1_errp(:,:,ses1_label==1),3);
errp_cr1=mean(ses1_errp(:,:,ses1_label==2),3);


if plotfig==1
figure; hold on; 
plot(t,errp_cr1(20,:),'k','linewidth',3) 
plot(t,errp_er1(20,:),'r','linewidth',3)
legend('Correct','Error');
xlabel('time (s)','FontSize',8)
ylabel('Amplitude (uV)','FontSize',8)
title('channel FCz (average of all sessions)','fontweight','bold')                               

end

save(['D:\ErrPDatasets\Kaggle P300 Speller\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(pno)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1', 'ses2_errp', 'ses2_label', 'N_tst2');


end


