function SNR=gp_var_SNR(x)
%metodo usado em Muller, e outros ...

mean_x=mean(x,1);
x_without_mean=x-repmat(mean_x,size(x,1),1);

SNR=var(mean_x)/mean(var(x_without_mean,0,2));

end