function [z1_f, z2_f]=FCB_projections(z1,z2,U)
% function [yt_f ynt_f]=FCB_projections(z1,z2,U)
% 
% Applies FCB spatial filters (obtained in FCB_spatial_filters) on data of the two classes 
%Inputs:
% z1: trials class 1   (format channels x time samples x trials 
% z2: trials class 2
% U: spatial filters (ordered by relevance)
% Outputs:
% z1_f: spatially filtered trials class 1 
% z2_f: spatially filtered trials class 2
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

%initialize variables
z1_f=zeros(size(z1,1),size(z1,2),size(z1,3));
z2_f=zeros(size(z2,1),size(z2,2),size(z2,3));

for i=1:size(z1,3)    %trials class 1
        z1_f(:,:,i)=U'*squeeze(z1(:,:,i)); 
end
for i=1:size(z2,3)    %trials class 2
        z2_f(:,:,i)=U'*squeeze(z2(:,:,i)); 
end

end