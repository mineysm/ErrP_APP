%Mine Yasemin August 2021
%load Game Agent data and save as subject*.mat files	
% https://ieee-dataport.org/documents/errp-dataset
clear;
clc;
nofses=[2 2 2 2 1 1 1 2]; %number of sessions
participant = [1 2 3 4 5 6 7 8];
plotfig=1; %option for plotting figures
Fold=10;
fdtime=2;  % event duration after feedback 
car=0;
lf=1;
hf=10;
cn=8; 
channelnames = [ "FZ "  "CZ "  "P3 "  "PZ "  "P4 "  "PO7 "  "PO8 "  "OZ "];
ytarget_cne_all = [];
visual_all = [];
for p=1:length(participant)
p_id=participant(p);
fprintf("Participant %d\n",p_id);  
fprintf("---------------\n");
fc=[1 20]; % 
visual=[];
N_tst=[];
for exp=1:nofses(p)
    fprintf("Session %d\n",exp);  
    names = dir(['D:\ErrPDatasets\Gaming Agent\subject',num2str(p_id),'\subject',num2str(p_id),'-',num2str(exp),'\*.vhdr']);
     fname = names.name(1:end);
    fileloadname=[names.folder,'\',fname];

    EEG = pop_loadbv(names.folder,fname);


    fs=EEG.srate;
    %eeg_eventtypes(EEG);

EEG.data = car_bpfilter(EEG.data,car,cn,fs,lf,hf);

%Pre-processing steps in the paper
% 1) bandpass filter of 0.1-20.0 Hz
%EEG = pop_eegfiltnew(EEG, 0.1, 20);

% 2) extract epochs
[EEGcor, indices1] = pop_epoch(EEG,{'OVTK_StimulationId_Number_01'},[-0.2 fdtime],...
'newname','correct epochs',...
'epochinfo','yes');
[EEGerr, indices2] = pop_epoch(EEG,{'OVTK_StimulationId_Number_02'},[-0.2 fdtime],...
'newname','error epochs',...
'epochinfo','yes');

%EEG = pop_rmbase(EEG);
% 3) Minmaxscaler
%EEGcor.data=normalizeData(EEGcor.data);
%EEGerr.data=normalizeData(EEGerr.data);
%%

Xtrain = cat(3, EEGerr.data,  EEGcor.data); 
Ytrain = [zeros(1,size(EEGerr.data,3)) ones(1,size(EEGcor.data,3))];
Ytrain = Ytrain +1;
randId = randperm(length(Ytrain));

  
tpoints = EEGerr.times;
twin = 1:fdtime*fs;

y_cne = Xtrain(:, :, randId); 
vis = Ytrain(randId);

N_tst(exp,1) = length(vis);
visual=[visual vis];

if exp==1
    ytarget_cne = y_cne;
else
    ytarget_cne = cat(3, ytarget_cne, y_cne);
end
clear EEG EEGcor EEGerr y_cne vis
end


save(['D:\ErrPDatasets\Gaming Agent\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p)],'p_id', 'channelnames', 'ytarget_cne','visual', 'N_tst');

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
for ch=1:8
    plot(tpoints,C1_t(ch,:),'b')
    hold on
end
for ch=1:8
    plot(tpoints,C1_nt(ch,:),'r')
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

ytarget_cne_all = cat(3, ytarget_cne_all, ytarget_cne);
visual_all = [visual_all visual];

end

C1_t_all=mean(ytarget_cne_all(:,:,visual_all==1),3);
C1_nt_all=mean(ytarget_cne_all(:,:,visual_all==2),3);
figure;

for ch=1:8
    p1=plot(tpoints/1000,C1_t_all(ch,:),'r');
    hold on
end
for ch=1:8
    p2=plot(tpoints/1000,C1_nt_all(ch,:),'b');
end
hold off
axis tight
title('Trial averaged data - Cz' ); %all channels');
h1= [p1(1); p2(1)];
legend(h1,'Error','Correct')
xlabel('time')
ylabel('amplitude')




