function [tmpy tmpw val perror]=gp_Bayes_class(x,auxmod1,auxmod2,prior1,prior2,C1,C2,type)
%[tmpy tmpw]=gp_Bayes_class(x,auxmod1,auxmod2,prior1,prior2,C1,C2,type)
%gpires Março 2008
    
  mediaModelo1=mean(auxmod1,2);
  mediaModelo2=mean(auxmod2,2); 

  switch type
      case 'diag'
          %covModelo1=var(auxmod1,0,2);   %apenas a diagonal ou metodo
          %alternativo em q faço diag(covmodelo)
          %covModelo2=var(auxmod2,0,2);
          
          covModelo1=diag(sum(auxmod1.^2,2)/(size(auxmod1,2)));
            covModelo2=diag(sum(auxmod2.^2,2)/(size(auxmod2,2)));
          
          %Caso utilize LOG-likelihood são as 8 linhas seguintes 
          B1=sum( log( 1./(sqrt(2*pi*diag(covModelo1)))) - 0.5*(x-mediaModelo1).^2./diag(covModelo1 ));
          B2=sum( log( 1./(sqrt(2*pi*diag(covModelo2)))) - 0.5*(x-mediaModelo2).^2./diag(covModelo2) );
          A1=log(C1);  %custo
          C1=log(prior1);
          A2=log(C2);
          C2=log(prior2);
          bayesclass1=A1+B1+C1;
          bayesclass2=A2+B2+C2;
            
%             bayesclass1= C1*prior1'*pdfgauss(x,mediaModelo1,covModelo1);
%             bayesclass2= C2*prior2'*pdfgauss(x,mediaModelo2,covModelo2);
       case 'full'
            XC=auxmod1-mediaModelo1*ones(1,size(auxmod1,2));
            covModelo1=XC*XC'/(size(auxmod1,2));  %metodo2 
            XC=auxmod2-mediaModelo2*ones(1,size(auxmod2,2));
            covModelo2=XC*XC'/(size(auxmod2,2));  %metodo2
           %varfullModelo1=cov(auxmod1');  %metodo1 com o comando cov
           bayesclass1= C1*prior1'*pdfgauss(x,mediaModelo1,covModelo1);
           %bayesclass1=gauss_likelihood(x-mediaModelo,covModelo1,0);  %abordagem 2
           %varfullModelo2=cov(auxmod2');
           bayesclass2= C2*prior2'*pdfgauss(x,mediaModelo2,covModelo2);
           %bayesclass2=gauss_likelihood(x-mediaModelo2,covModelo2,0);  %abordagem 2
      
  end

 
  %equivale à expressão 'argmax' devolve valor do classificador e posicao
  [tmpw,tmpy] = max([bayesclass1 bayesclass2]);
  
  %propabilidade de erro associado à escolha
  perror = 1-tmpw./sum([bayesclass1; bayesclass2],1);

  val=[bayesclass1 bayesclass2]; %valor de probabilidade de pertencer à classe respectiva
  
end