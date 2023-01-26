function [errp1, errp2]=ac_ErrP_data(y,eeg,tbf)
    
    id_error=gp_findindex(eeg(14,:),100);
    id_er = id_error(1:38);
    id_tr=1;
    for i=1:size(id_er,2)
            for a1=1:12
                errp1(a1,:,id_tr)=y(a1,id_er(i)-round(tbf*256):id_er(i)+256-1); 
                errp2(a1,:,id_tr)=y(a1,id_er(i)+256:id_er(i)+256*2-1); 
            end 
            id_tr=id_tr+1;
    end
end
