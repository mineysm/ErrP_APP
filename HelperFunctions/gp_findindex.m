function ind=gp_findindex(file,id)
%function ind=find_index(file)
%Devolve a amostra trigger associado a cada evento de flash (note-se q os eventos devem aparecer sempre entre 0s)
%file: matriz que corresponde ao carregamento do ficheiro
%id: evento pretendido, por exemplo se for a seta 4 id=4

ind=[];
[trig tam]=size(file);

j=1;
trigger=file(trig,:);

for i=1:tam-1
    if (trigger(i)~=id) &&  (trigger(i+1)==id)
        ind(j)=i+1;
        j=j+1;
    end
end
