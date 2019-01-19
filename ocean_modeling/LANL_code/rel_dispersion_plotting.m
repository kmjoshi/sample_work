function rel_dispersion_plotting()
grdnum = 1; f = 2; level = 1; seas_in = 0; iferror = 0; ifclean = 0;
for grdnum = [1,3]
    for level = 1:4
        dt = 0.25;
Lt = zeros(3,2,4); Lt(:,1,1) = [4.5,0,2.5]; Lt(1,2,:) = [6,6,7,12]; Lt(3,2,:) = [3,3,3,8];
dispm = 1/1000000; % transform from m^2 to km^2 (3600*24)^2; 
lagm = 1/4; %6*3600;
if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
end
lvec = {'15m' '30m' '60m' '150m'};
flstrvec = {'2d_z15m' '3d'};

%if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['rel_disp',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename])

tend = find(nstar(3:end) <= 100,1,'first');
if isempty(tend); tend = length(nstar); end

x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yp = (dispavg(1:tend)+err(1:tend))*dispm;
y = dispavg(1:tend)*dispm;
ym = (dispavg(1:tend)-err(1:tend))*dispm;
y2 = diff(log10(dispavg(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));

figure(1); clf
plot(x1,y,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,yp,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,ym,'LineStyle',':','Color',[0.65 0 0.13]); hold on

xlim([0,tend*lagm]);
xlabel('days')
ylabel('km^2')
ptitle = ['2D relative dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
%legend('u','v','Location','Best')
text_line(1)
grid on

filename = ['reldisp_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

% figure(2); clf
% plot(x2,y2,'LineStyle','-','Color',[0.65 0 0.13]); hold on
% plot(x2,y2,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
% xlim([0,tend*lagm]);
% ylim('auto');
% xlabel('days')
% legend('u','v','Location','Best')
% ptitle = ['UV relative dispersion slope ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
% title(ptitle)
% text_line(2)
% set(gca,'xscale','linear','yscale','linear')
% grid minor
% filename = ['reldisp_slope_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
% export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end
end
end
