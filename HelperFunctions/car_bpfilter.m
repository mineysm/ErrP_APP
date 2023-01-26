function [BPCAR] = car_bpfilter(y,car,chn,fs,lf,hf)
    % y is eeg matrix, channel x time
    d = fdesign.bandpass ('N,F3dB1,F3dB2', 4, lf, hf, fs);
    Hd = design (d,'butter');
    ytemp = y';
    for c = 1:chn
        if car==1 
                CAR = common_average_reference (ytemp(:,c), ytemp);
                BPCAR(c,:) = filter (Hd, CAR);
        else
                BPCAR(c,:) = filter (Hd, ytemp(:,c));
        end		        
    end        
end