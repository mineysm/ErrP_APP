
function  ind = hs_IndexHipnog(data,a,b)

ind =[];
for i=a:b
   in=find(data==i);
   ind = [ind in]; 
end