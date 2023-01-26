function [normalizedDataset]=normalize2dData(datasetMatrix)

    for i=1:size(datasetMatrix,2) %trial
        
        normalizedDataset(:,i)=(datasetMatrix(:,i)-mean(datasetMatrix(:,i)))/std(datasetMatrix(:,i));

    end

end