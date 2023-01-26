function [tmpy, val, perror]=sf_process_algorithm(x,Nev,win,modeloT,modelononT,prior1,prior2)

%x (id,samples)
for id=1:size(x,1)%Nev
    [tmpy(id), tmpw(id), val(id,:), perror(id)]=sf_Bayes_class(x(id,win)',modeloT,modelononT,prior1,prior2,'diag');
end
