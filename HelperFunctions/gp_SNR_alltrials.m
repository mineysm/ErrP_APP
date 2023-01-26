function SNR_final=gp_SNR_alltrials(x,meth)
%formula obtida de Coppola
%calcula a relacao sinal/ruido com base em todas as trials
%aplicado a um unico canal
%gpires 18/12/2009

[Ntrial Tsamp]=size(x);

trials=floor(Ntrial/2); %divide as trials em 2 conjuntos e obtem o nr de trials por conjunto

switch meth
    case 1 %metodo Maximum Likelihood
        for i=1:trials
            SNR(i)=gp_ML_SNR(x(i,:),x(i+trials,:)); %obtem SNR de pares de trials
        end
    case  2 %metodo baseado em correla��o
        for i=1:trials
            SNR(i)=gp_r_SNR(x(i,:),x(i+trials,:));
        end
    case 3 %metodo baseado no template
            SNR=gp_var_SNR(x);
    case 4 %metodo baseado na rela�ao entre pot sinal e varancia (semelhante ao metodo 3)
            SNR=gp_P_var_SNR(x);
end
    

SNR_final=mean(SNR);