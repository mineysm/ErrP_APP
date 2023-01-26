%Mine Yasemin August 2021
%load Gaze Speller data and save as subject*.mat files	
% https://doi.org/10.6084/m9.figshare.5938714.v1
clear;
participant = [1 2 3 4 5 6 7 11 13 15];
pltopt=1;
car=0;
lf=1;
hf=10;
N_tst1 = 0;
cn= 61; 
channelnames = ["AF7" "AF3" "FP1" "FP2" "AF4" "AF8" "F7" "F5" "F3" "F1" "F2" "F4" "F6" "F8" ...
    "FT7" "FC5" "FC3" "FC1" "FC2" "FC4" "FC6" "FT8" "T3" "C5" "C3" "C1" "C2" "C4" "C6" "T4" "TP7" ...
    "CP5" "CP3" "CP1" "CP2" "CP4" "CP6" "TP8" "T5" "P5" "P3" "P1" "P2" "P4" "P6" "T6" "FPZ" ...
    "PO7" "PO3" "O1" "O2" "PO4" "PO8" "OZ" "AFZ" "FZ" "FCZ" "CZ" "CPZ" "PZ" "POZ"];
fs= 256;
for pno = participant
p_id = num2str(pno);
fprintf("Subject %s\n",p_id);  
fprintf("---------------\n");
switch pno
    case 1
    load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S01.eeg_trials;
   labels = S01.labels;
    case 2
  load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S02.eeg_trials;
   labels = S02.labels;
   case 3
    load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S03.eeg_trials;
   labels = S03.labels;
    case 4
  load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S04.eeg_trials;
   labels = S04.labels;
     case 5
    load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S05.eeg_trials;
   labels = S05.labels;
    case 6
  load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S06.eeg_trials;
   labels = S06.labels;
   case 7
    load( ['D:\ErrPDatasets\Gaze Speller\S0',num2str(pno),'.mat']);
   traindata = S07.eeg_trials;
   labels = S07.labels;
    case 11
  load( ['D:\ErrPDatasets\Gaze Speller\S',num2str(pno),'.mat']);
   traindata = S11.eeg_trials;
   labels = S11.labels;
   case 13
  load( ['D:\ErrPDatasets\Gaze Speller\S',num2str(pno),'.mat']);
   traindata = S13.eeg_trials;
   labels = S13.labels;
   case 15
  load( ['D:\ErrPDatasets\Gaze Speller\S',num2str(pno),'.mat']);
   traindata = S15.eeg_trials;
   labels = S15.labels;
end


visual= zeros(1,length(labels));
for i=1:length(labels)
    if labels(i)==-1
        visual(i)=1;
    else
        visual(i)=2; 
    end
end
%tw=1:fs*fdtime;
%tw= 53:180;  % ,  0-500 ms
Xdata=traindata(:,:,:); %1:fs*fdtime); 
ses1_errp= permute(Xdata, [2 3 1]);
ses1_label = visual;



if pltopt==1
meanerr = mean(ses1_errp(:,:,ses1_label==1),3);
meancor = mean(ses1_errp(:,:,ses1_label==2),3);
    % Plot the results
time_range = 1:180;
channel = 57; %FCz
figure;
plot(time_range, meancor(channel,:), 'b', 'linewidth', 3); grid on, hold on;
plot(time_range, meanerr(channel,:), 'r', 'linewidth', 3); 
legend('Correct action', 'Error action');
plot([0 0], get(gca, 'YLim'), 'k', 'linewidth', 2);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title(['Grand average subject ' num2str(pno)]);
end

save(['D:\ErrPDatasets\Gaze Speller\trials\subject',num2str(pno)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1');

end