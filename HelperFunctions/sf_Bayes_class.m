function [tmpy tmpw val perror]=sf_Bayes_class(x,auxmod1,auxmod2,prior1,prior2,type)
%[tmpy tmpw]=gp_Bayes_class(x,auxmod1,auxmod2,prior1,prior2,C1,C2,type)
%gpires Março 2008

mediaModelo1=mean(auxmod1,2);
mediaModelo2=mean(auxmod2,2);


covModelo1=diag(sum(auxmod1.^2,2)/(size(auxmod1,2)));
covModelo2=diag(sum(auxmod2.^2,2)/(size(auxmod2,2)));

%Caso utilize LOG-likelihood são as 8 linhas seguintes 
B1=sum( log( 1./(sqrt(2*pi*diag(covModelo1)))) - 0.5*(x-mediaModelo1).^2./diag(covModelo1 ));
B2=sum( log( 1./(sqrt(2*pi*diag(covModelo2)))) - 0.5*(x-mediaModelo2).^2./diag(covModelo2) );
%A1=log(C1);  %custo
C1=log(prior1);
%A2=log(C2);
C2=log(prior2);
bayesclass1=(B1+C1);
bayesclass2=(B2+C2);
%   bayesclass1=(A1+B1+C1);
%   bayesclass2=(A2+B2+C2);

[tmpw,tmpy] = min([bayesclass1/(bayesclass1+bayesclass2) bayesclass2/(bayesclass1+bayesclass2)]);

%propabilidade de erro associado à escolha
perror = 1-tmpw./sum([bayesclass1; bayesclass2],1);

val=[bayesclass1 bayesclass2]; %valor de probabilidade de pertencer à classe respectiva 

end  