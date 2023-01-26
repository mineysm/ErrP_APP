%Mine Yasemin August 2021
%load Tactile data and save as subject*.mat files	
% https://teep-sla.eu/index.php/results/40-smc2017-dataset
exp=1;
participant= [1 2 3 4 5 6 7 8 9 10 11 12];
stimuli = ["Dis", "Dis", "Con", "Con","Dis", "Dis", "Con", "Con", "Con","Dis", "Dis", "Con"];
 plotfig=1;
 fdtime=1.5;
 beforefdb = 0.2;
 car=0;
lf=1;
hf=10;
cn=16; 
channelnames = ["Fz"	"FC3"	"FC1"	"FCz"	"FC2"	"FC4"	"C3"	"C1"	"Cz"	"C2"	"C4"	"CP3"	"CP1"	"CPz"	"CP2"	"CP4"];
 for p_id=participant
ses1_errp = [];
ses1_label = [];
N_tst1 = [];
if exp==1  %visual stimuli - V
        if p_id<10
            load( ['D:\ErrPDatasets\Tactile Feedback (V)\errPdataVfeedback_mat\S0',num2str(participant(1,p_id)),'V.mat']);
        else
            load( ['D:\ErrPDatasets\Tactile Feedback (V)\errPdataVfeedback_mat\S',num2str(participant(1,p_id)),'V.mat']);
        end       
elseif exp==2 %concordant or discordant visual and tactile stimuli - VT
         if p_id<10 &&  stimuli(1,p_id)=="Dis"
           load( ['D:\ErrPDatasets\Tactile Feedback (VT)\errPdataVTfeedback_mat\S0',num2str(participant(1,p_id)),'DisVT.mat']);
         elseif p_id<10 &&  stimuli(1,p_id)=="Con"
            load( ['D:\ErrPDatasets\Tactile Feedback (VT)\errPdataVTfeedback_mat\S0',num2str(participant(1,p_id)),'ConVT.mat']);
         elseif p_id>9 &&  stimuli(1,p_id)=="Dis"
           load( ['D:\ErrPDatasets\Tactile Feedback (VT)\errPdataVTfeedback_mat\S',num2str(participant(1,p_id)),'DisVT.mat']);
         elseif p_id>9 &&  stimuli(1,p_id)=="Con"
            load( ['D:\ErrPDatasets\Tactile Feedback (VT)\errPdataVTfeedback_mat\S',num2str(participant(1,p_id)),'ConVT.mat']);
        end
end
    fprintf("Subject %s\n",expData.subject);  
    fprintf("---------------\n");
    
     rawdata = expData.rawData;
     fs= expData.samplingRate;
     labels = expData.labelTimeStamps(2,:);
     EEG = pop_importdata('data',rawdata', 'srate',fs, 'nbchan', 16 );
    
      for i=1:size(expData.labelTimeStamps,2)
            EEG.event(i).type = expData.labelTimeStamps(2,i);
            EEG.event(i).latency =  expData.labelTimeStamps(1,i);
            EEG.event(i).duration = fs*fdtime;
      end
     %EEG = pop_reref( EEG, []);
    
      EEG.data = car_bpfilter(EEG.data,car,cn,fs,lf,hf);  

     [EEG, indices] = pop_epoch(EEG,{1 2},[-1*beforefdb fdtime],...
'newname','feedback epochs',...
'epochinfo','yes');
 %EEG = pop_rmbase(EEG,[-100 0]);

 ErrPdata = EEG.data;
 FBstarttime = beforefdb*fs;

 twin = round(FBstarttime+1):round(FBstarttime+fdtime*fs);
 % traindata = ErrPdata(:,twin,:);
ses1_errp = ErrPdata(:,:,:);
  
    visual= zeros(1,length(labels));
for i=1:length(labels)
    if labels(i)==2
        visual(i)=1;
    else
        visual(i)=2; 
    end
end
 ses1_label =  visual;
 t= EEG.times; 
 if plotfig==1
         zspatialTRAIN_t = ses1_errp(:,:,visual==1);
         zspatialTRAIN_nt =  ses1_errp(:,:,visual==2);
         C1_t=mean(zspatialTRAIN_t,3);
         C1_nt=mean(zspatialTRAIN_nt,3);
                figure;
                title('Trial averaged data');
                for ch=1:16
                    plot(t,C1_t(ch,:),'b')
                    hold on
                    plot(t,C1_nt(ch,:),'r')
                end
                hold off
                h=legend('ErrP target','non target');
                xlabel('time (s)')
                ylabel('Amplitude')
  end

    if exp==1
        save(['D:\ErrPDatasets\Tactile Feedback (V)\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p_id)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1');
    else
        save(['D:\ErrPDatasets\Tactile Feedback (VT)\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p_id)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1');
    end

 end