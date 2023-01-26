function label=ac_ErrP_Label(eeg,type)
    if type==1
        id_dif=find(eeg(15,:)==1 | eeg(15,:)==2);
        label=eeg(15,id_dif);
    elseif type==2
        id_dif=find(eeg(15,:)==1 | eeg(15,:)==2);
        id_dif2=find(eeg(15,:)==3 | eeg(15,:)==4);
        
        err2=eeg(15,id_dif2);
        [~,~,Ib] = intersect(id_dif2,id_dif+255);
        label=zeros(1,38);
        label(Ib)=err2;
    else
        disp('Wrong Id')
    end
end

