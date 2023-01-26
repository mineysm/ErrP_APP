function [perf, result, dtime] = classifyacrosstime(ytrain,clabel, fs, tstart, tend,rep,kfold)
        cfg = [];
        cfg.classifier = 'lda';
        cfg.metric      = 'auc'; % 'accuracy', 'auc'
        cfg.repeat = rep; %10 times 10 fold cross validation
        cfg.k = kfold; %10 times 10 fold cross validation
        % [samples x channels x time points]
        [perf, result] = mv_classify(cfg, ytrain, clabel);
        dtime = linspace(tstart,tend,size(ytrain,3));
       
end