function plot_rsquare(t,ressq)
%function plot_rsquare(t,ressq)
%t - instantes temporais
%ressq - valor de r2

data2plot=ressq';
data2plot=cat(2, data2plot, zeros(size(data2plot, 1), 1));
data2plot=cat(1, data2plot, zeros(1, size(data2plot, 2)));
xData=t;
xData(end+1) = xData(end) + diff(xData(end-1:end));

Ncanais=size(ressq,2);
surf(xData, [1:Ncanais + 1], data2plot,'EdgeColor','none'); %opção sem edges
axis tight;
view(2);
colormap jet;
colorbar;
xlabel('time [s]','Color','w');
ylabel('channels','Color','w');
title('Statistical r^2between target and non-target','Color','w','FontWeight','bold'); 
set(gcf,'Renderer','Zbuffer')
% ticks = get(gca, 'ytick');
% ticklabels = num2str(ticks');
% set(gca, 'ytick', ticks+.5);
% set(gca, 'yticklabel', ticklabels);