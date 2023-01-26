function finalVECT = hs_mat2vect(initialMAT)
% Converts an array of data (initialMAT) for a data vector (finalVECT)

auxSize = size(initialMAT,1);
finalVECT = [];

for inc=1:auxSize
    vectAUX = initialMAT(inc,:);
    finalVECT = [finalVECT vectAUX];
end
end