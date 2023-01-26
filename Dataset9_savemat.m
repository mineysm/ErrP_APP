%Mine Yasemin August 2021
%load Virtual Cursor data and save as .mat files	
% https://github.com/flowersteam/self_calibration_BCI_plosOne_2015
clear;
pltopt=1;
car=0;
lf=1;
hf=10;
N_tst1 = 0;
cn=16;  
channelnames = ["Fz"	"FC3"	"FC1"	"FCz"	"FC2"	"FC4"	"C3"	"C1"	"Cz"	"C2"	"C4"	"CP3"	"CP1"	"CPz"	"CP2"	"CP4"];
 
for p_id=1:8
ses1_errp = [];
ses1_label = [];
fprintf("Subject %d\n",p_id);  
fprintf("---------------\n");
load(['D:\ErrPDatasets\Virtual Cursor\EEG_s' num2str(p_id) '.mat']);
events = {'correct_movement', 'error_movement'};
time_window = [-200 1000]; % in ms, where 0 ms is the event onset (i.e. the device performed an action
time_window_samples = round(time_window * EEG.sample_rate / 1000);
 y = EEG.signal;
fs = EEG.sample_rate;

y_sel = y';
y_sel = car_bpfilter(y_sel,car,cn,fs,lf,hf);

for i=1:length(EEG.events.name)
    y_cne(:,:,i) = y_sel(:,EEG.events.position(i)+time_window_samples(1):EEG.events.position(i)+time_window_samples(2));
    labels(i) = strcmp(EEG.events.name(i), events{1})+1;
end
twin= round(0.2*fs+1:1.2*fs);
ses1_errp = y_cne(:,:,:);
ses1_label = labels;

if pltopt==1
meanerr = mean(ses1_errp(:,:,ses1_label==1),3);
meancor = mean(ses1_errp(:,:,ses1_label==2),3);
    % Plot the results
time_range = time_window(1):1000/EEG.sample_rate:time_window(2);
channel = 4; %FCz
figure;
plot(time_range, meancor(channel,:), 'b', 'linewidth', 3); grid on, hold on;
plot(time_range, meanerr(channel,:), 'r', 'linewidth', 3); 
legend('Correct action', 'Error action');
plot([0 0], get(gca, 'YLim'), 'k', 'linewidth', 2);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title(['Grand average subject ' num2str(p_id)]);
end

save(['D:\ErrPDatasets\Virtual Cursor\CAR',num2str(car),'_BP',num2str(lf),'-',num2str(hf),'\subject',num2str(p_id)],'p_id', 'channelnames', 'ses1_errp', 'ses1_label', 'N_tst1');

end