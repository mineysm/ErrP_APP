function [U1, V1]=FCB_spatial_filters(z1,z2,th)
% function [U1 V1] = FCB_spatial_filters(z1,z2,th)
%
% Obtains FCB statistical spatial filters maximizing the discrimnation between two classes 
% Inputs:
% z1: trials class 1   (format channels x time samples x trials 
% z2: trials class 2
% th: regularization parameter
% Outputs:
% U1: eigenvectors (spatial filters odered by relevance)
% V1: eigenvalues
%
% Implementation of "Fisher Criterion Beamformer (FCB)" according to paper below (section 3.2.2):
%
% Gabriel Pires, Urbano Nunes and  Miguel Castelo-Branco (2011), "Statistical Spatial Filtering for 
% a P300-based BCI: Tests in able-bodied, and Patients with Cerebral Palsy and Amyotrophic Lateral 
% Sclerosis", Journal of Neuroscience Methods, Elsevier, 2011, 195(2), 
% Feb. 2011: doi:10.1016/j.jneumeth.2010.11.016
% https://www.sciencedirect.com/science/article/pii/S0165027010006503?via%3Dihub
%
% Gabriel Pires 02/2011

Mean1=mean(z1,3);
Mean2=mean(z2,3);

Cov1=zeros(size(z1,1),size(z1,1),size(z1,3));
Cov2=zeros(size(z2,1),size(z2,1),size(z2,3));

for i=1:size(z1,3)                             %for each trial in class 1 
    aux1=(z1(:,:,i)-Mean1)*(z1(:,:,i)-Mean1)';
    Cov1(:,:,i)=aux1/(trace(aux1));            %normalized spatial covariance per trial 
end

for i=1:size(z2,3)   %nr de trials
    aux2=(z2(:,:,i)-Mean2)*(z2(:,:,i)-Mean2)'; %for each trial in class 2
    Cov2(:,:,i)=aux2/(trace(aux2));            
end

p1=size(z1,3)/(size(z1,3)+size(z2,3));
p2=size(z2,3)/(size(z1,3)+size(z2,3));

Covavg1=sum(Cov1,3); %scovariances sum class 1  
Covavg2=sum(Cov2,3); %scovariances sum class 2 

MeanAll=p1*Mean1+p2*Mean2;   %forma correcta uma vez q os dataset são desiquilibrados

%Spatial BETWEEN-CLASS MATRIX
Sb=p1*(Mean1-MeanAll)*(Mean1-MeanAll)'+p2*(Mean2-MeanAll)*(Mean2-MeanAll)';  

%Spatial WITHIN-CLASS MATRIX
Sw=p1*Covavg1+p2*Covavg2;  
Sw= (1-th)*Sw + th*eye(size(Sw,1),size(Sw,1));  

[U1, V1]=eig(pinv(Sw)*Sb); 


Vd1 = diag(V1);
[junk, rindices] = sort(-1*Vd1);   
Vd1 = Vd1(rindices);               %ordered eigen values 
V1=diag(Vd1);                      
U1 = U1(:,rindices);               %ordered eigenvectors (spatial filters)

end