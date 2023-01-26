function [pred,results,TN,TP,FN,FP]=performance(vishyp,authyp,a,b,c)

ind =[];
for i=a:b
   in=find(vishyp==i);
   ind = [ind in]; 
end

TstLabel1=vishyp(ind)';
predict_label1= authyp(ind)';


for i=a:b
   class(i,1)=length(find(TstLabel1(:,1)==i));
end

a=1;
for i=1:length(class)
    for j=1:length(class)
        pred(j,i)= length(find(predict_label1(a:a+class(i)-1,1)==j));
    end
    a=a+class(i);
end

Sensibility=zeros(1,length(class));
Specificity=zeros(1,length(class));
acuracy=zeros(1,length(class));
for i=1:length(class)
    col=1:length(class);
    col(i)=[];
    lin=1:length(class);
    lin(i)=[];
    

    TN=sum(sum(pred(lin,col)));
    FP=sum(sum(pred(i,col)));
    FN=sum(sum(pred(lin,i)));
    TP=pred(i,i);
    
    sens=(TP/(TP+FN))*100;
    Sensibility(1,i) = sens;

    spec=((TN)/(TN+FP))*100;
    Specificity(1,i)=spec;
    
    if c==1
    acc=(sens+spec)/2; % balanced accuracy
    else        
    acc=((TP+TN)/(FN+TN+FP+TP))*100;
    end
    acuracy(1,i)=acc;
 
end
 
results=[Sensibility;Specificity;acuracy];

