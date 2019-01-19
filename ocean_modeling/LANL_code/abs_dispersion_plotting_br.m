function abs_dispersion_plotting_br(plot_in)
%% plot_in == 1; uv
%% plot_in == 2; w
%% plot_in == 3; 2d
%
grdnum = 1; f = 1; level = 1; seas_in = 0; ifclean = 1; seas = 1;
%for f = 1:2
%   for level = 1:4
%    if f == 1 & level > 1; continue; end
for grdnum = [1,3]
dt = 0.25;
Lt = zeros(3,2,4); Lt(:,1,1) = [5.25,0,2.5]; Lt(1,2,:) = [6,6,7,12]; Lt(3,2,:) = [3,3,3,8];
HR_version = 1;
saveload = 0;
dispm = ((0.25*3600*24/1000)^2); % multiply by a factor of 1000*dt2 since dispersion is in m2/s2
lagm = 1/4; %6*3600;
ttt = 1461;

if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
end
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    %grd = rnt_gridload('soatl1');
    npart = 6482;
elseif grdnum == 3;
    if HR_version == 1
        timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
            '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    elseif HR_version == 2
        timestrvec = {'1999M08D01' '1999M08D06' '1999M08D11' '1999M08D16' '1999M08D21' ...
            '1999M08D26' '1999M08D31' '1999M09D05' '1999M09D10' '1999M09D15' '1999M09D20' ...
            '1999M09D25' '1999M09D30' '1999M10D05' '1999M10D10' '1999M10D15' '1999M10D20' ...
            '1999M10D25' '1999M10D30' '1999M11D04' '1999M11D09' '1999M11D14' '1999M11D19' ...
            '1999M11D24' '1999M11D29' '1999M12D04' '1999M12D09' '1999M12D14' '1999M12D19' ...
            '1999M12D24' '1999M12D29' '2000M01D03' '2000M01D08' '2000M01D13' '2000M01D18' ...
            '2000M01D23' '2000M01D28' '2000M02D02' '2000M02D07' '2000M02D12' '2000M02D17' ...
            '2000M02D22' '2000M02D27' '2000M03D03' '2000M03D08' '2000M03D13' '2000M03D18' ...
            '2000M03D23' '2000M03D28' '2000M04D02' '2000M04D07' '2000M04D12' '2000M04D17' ...
            '2000M04D22' '2000M04D27' '2000M05D02' '2000M05D07' '2000M05D12' '2000M05D17' ...
            '2000M05D22' '2000M05D27' '2000M06D01' '2000M06D06' '2000M06D11' '2000M06D16' ...
            '2000M06D21' '2000M06D26' '2000M07D01' '2000M07D06' '2000M07D11' '2000M07D16' ...
            '2000M07D21' '2000M07D26'};
    end
    npart = 4980;
end
lvec = {'15m' '30m' '60m' '150m'};
flstrvec = {'2d_z15m' '3d'};

flstr = flstrvec{f};

% load absolute dispersion uvw
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/';
    
dispuu = zeros(ttt-1,npart); dispvv = zeros(ttt-1,npart); 
dispww = zeros(ttt-1,npart);
disp2dd = zeros(ttt-1,npart); 
nlagr = zeros(ttt-1,npart);

if ~seas
if saveload
    
for r = 1:length(timestrvec)
timestr = timestrvec{r};
filename = ['dispuvw_',flstr(1:2),'_',timestr,'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename])

dispuu = dispuu + dispu; dispvv = dispvv + dispv; 
dispww = dispww + dispw;
disp2dd = disp2dd + disp2d.^2; 
nlagr = nlagr + nlag;

end

nlag = nansum(nlagr,2);
dispu = nansum(dispuu,2)./nlag;
dispv = nansum(dispvv,2)./nlag;
dispw = nansum(dispww,2)./nlag;
disp2d = nansum(disp2dd,2)./nlag;
lagvec = (0:1:length(nlag)-1)';

nstar = nlag*(dt/(2*Lt(grdnum,f,level)));

if ifclean
    nstar = nlag*(dt/(2*Lt(grdnum,f,level)));
    erru = 1.96*dispu.*sqrt(2./(nstar-1));
    errv = 1.96*dispv.*sqrt(2./(nstar-1));
    errw = 1.96*dispw.*sqrt(2./(nstar-1));
    err2d = 1.96*disp2d.*sqrt(2./(nstar-1));
    %save([filepath,filename,'.mat'],'erru','errv','-append')
end

% save
filename = ['dispuvw_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
save([filepath,filename,'.mat'],'dispu','dispv','dispw','disp2d','lagvec','nstar',...
    'erru','errv','errw','err2d')
% end
else
filename = ['dispuvw_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'])

tend = find(nstar <= 100,1,'first');
if isempty(tend); tend = length(nlag); end

if plot_in == 1
    
x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yup = (dispu(1:tend)+erru(1:tend))*dispm;
yum = (dispu(1:tend)-erru(1:tend))*dispm;
yu = dispu(1:tend)*dispm;
yvp = (dispv(1:tend)+errv(1:tend))*dispm;
yvm = (dispv(1:tend)-errv(1:tend))*dispm;
yv = dispv(1:tend)*dispm;
yu2 = diff(log10(dispu(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));
yv2 = diff(log10(dispv(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));

figure(1); clf
plot(x1,yu,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,yv,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
plot(x1,yup,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,yum,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,yvp,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on
plot(x1,yvm,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on

xlim([0,tend*lagm]);
xlabel('days')
ylabel('km^2')
ptitle = ['Absolute Dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
legend('u','v','Location','Best')
text_line(1)
grid on

filename = ['annual_disp_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

elseif plot_in == 2

dispm = ((0.25*3600*24)^2); % multiply by a factor of dt2 since dispersion is in m2/s2

x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yw = dispw(1:tend)*dispm;
ywp = (dispw(1:tend)+errw(1:tend))*dispm;
ywm = (dispw(1:tend)-errw(1:tend))*dispm;
yw2 = diff(log10(dispw(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));

figure(1); clf
plot(x1,yw,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,ywp,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,ywm,'LineStyle',':','Color',[0.65 0 0.13]); hold on

xlim([0,tend*lagm]);
xlabel('days')
ylabel('m^2')
ptitle = ['Absolute W Dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
%legend('u','v','Location','Best')
text_line(1)
grid on

filename = ['annual_disp_w_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

elseif plot_in == 3

x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yd = disp2d(1:tend).^2*dispm;
ydp = (disp2d(1:tend).^2+err2d(1:tend).^2)*dispm;
ydm = (disp2d(1:tend).^2-err2d(1:tend).^2)*dispm;
yd2 = diff(log10(disp2d(1:tend).^2*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));

figure(1); clf
plot(x1,yd,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,ydp,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,ydm,'LineStyle',':','Color',[0.65 0 0.13]); hold on

xlim([0,tend*lagm]);
xlabel('days')
ylabel('km^2')
ptitle = ['Absolute 2D Dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
%legend('u','v','Location','Best')
text_line(1)
grid on

filename = ['annual_disp_2d_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end
end
elseif seas
    figure; %clf
    if grdnum == 1
        cvec = [0.65 0 0.13;0.164 0.043 0.85;0.97 0.43 0.37;0.25 0.63 1];
    elseif grdnum == 3
        cvec = [64,0,75;0,68,27;153,112,171;90,174,97]/256;
    end
    % Load seasonal dispersion
    %s1 = [6:9,11:12,1:3];
    %[~,mo,~,~,~,~] = datevec(timevec);
    %a = anyvec(mo,s1);
    %dispu(a ~= 1,:) = NaN; dispv(a ~= 1,:) = NaN;  dispw(a ~= 1,:) = NaN;
    %disp2d(a ~= 1,:) = NaN;
%for seas = 1:2
for seas = 1:2
    if seas == 1
    s = 6:9; str = 'JJAS';
elseif seas == 2
    s = [11,12,1,2,3]; str = 'NDJFM';
end
for r = 1:length(timestrvec)
timestr = timestrvec{r};
filename = ['dispuvw_seas_bc_',str,'_',flstr(1:2),'_',timestr,'_',num2str(grdnum),num2str(level),seas_str];
try load([filepath,filename]); catch; disp('No Release in season'); continue; end

dispuu = dispuu + dispu; dispvv = dispvv + dispv; dispww = dispww + dispw;
disp2dd = disp2dd + disp2d; nlagr = nlagr + nlag;

end

nlag = nansum(nlagr,2);
dispu = nansum(dispuu,2)./nlag;
dispv = nansum(dispvv,2)./nlag;
dispw = nansum(dispww,2)./nlag;
disp2d = nansum(disp2dd,2)./nlag;
lagvec = (0:1:length(nlag)-1)';

nstar = nlag*(dt/(2*Lt(grdnum,f,level)));

if ifclean
    nstar = nlag*(dt/(2*Lt(grdnum,f,level)));
    erru = 1.96*dispu.*sqrt(2./(nstar-1));
    errv = 1.96*dispv.*sqrt(2./(nstar-1));
    errw = 1.96*dispw.*sqrt(2./(nstar-1));
    err2d = 1.96*disp2d.*sqrt(2./(nstar-1));
    %save([filepath,filename,'.mat'],'erru','errv','-append')
end

tend = find(nstar <= 100,1,'first');
if isempty(tend); tend = length(nlag); end

if plot_in == 1
% x1 = lagvec(1:tend)*lagm;
% x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
% yup = (dispu(1:tend)+erru(1:tend))*dispm;
% yum = (dispu(1:tend)-erru(1:tend))*dispm;
% yu = dispu(1:tend)*dispm;
% yvp = (dispv(1:tend)+errv(1:tend))*dispm;
% yvm = (dispv(1:tend)-errv(1:tend))*dispm;
% yv = dispv(1:tend)*dispm;
% yu2 = diff(log10(dispu(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));
% yv2 = diff(log10(dispv(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));
x1 = lagvec*lagm;
x2 = (lagvec(1:end-1)+diff(lagvec)/2)*lagm;
yup = (dispu+erru)*dispm;
yum = (dispu-erru)*dispm;
yu = dispu*dispm;
yvp = (dispv+errv)*dispm;
yvm = (dispv-errv)*dispm;
yv = dispv*dispm;
yu2 = diff(log10(dispu*dispm))./diff(log10(lagvec*dt*sqrt(dispm)));
yv2 = diff(log10(dispv*dispm))./diff(log10(lagvec*dt*sqrt(dispm)));

%figure(1);
h(seas*2-1) = plot(x1,yu,'LineStyle','-','Color',cvec(seas*2-1,:)); hold on
h(seas*2) = plot(x1,yv,'LineStyle','-','Color',cvec(seas*2,:)); hold on
plot(x1,yup,'LineStyle',':','Color',cvec(seas*2-1,:)); hold on
plot(x1,yum,'LineStyle',':','Color',cvec(seas*2-1,:)); hold on
plot(x1,yvp,'LineStyle',':','Color',cvec(seas*2,:)); hold on
plot(x1,yvm,'LineStyle',':','Color',cvec(seas*2,:)); hold on
if grdnum == 1; g = h; end
elseif plot_in == 2

dispm = ((0.25*3600*24)^2); % multiply by a factor of dt2 since dispersion is in m2/s2

x1 = lagvec*lagm;
x2 = (lagvec(1:end-1)+diff(lagvec)/2)*lagm;
yw = dispw*dispm;
ywp = (dispw+errw)*dispm;
ywm = (dispw-errw)*dispm;
yw2 = diff(log10(dispw*dispm))./diff(log10(lagvec*dt*sqrt(dispm)));

%figure(1); clf
h(seas) = plot(x1,yw,'LineStyle','-','Color',cvec(seas,:)); hold on
plot(x1,ywp,'LineStyle',':','Color',cvec(seas,:)); hold on
plot(x1,ywm,'LineStyle',':','Color',cvec(seas,:)); hold on
if grdnum == 1; g = h; end

end

xlim([0,30]);
ylim([0,2.2e2]);
xlabel('days')
set(gca,'xscale','linear','yscale','linear')
%title(ptitle)
%text_line(1)
grid on
%export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end
end
hold on
end
gh = [g,h];
if plot_in == 1
        legend(gh,'JJAS U LR','JJAS V LR','NDJFM U LR','NDJFM V LR','JJAS U HR',...
        'JJAS V HR','NDJFM U HR','NDJFM V HR','Location','Best')
    ylabel('km^2')
    ptitle = ['Absolute Seasonal Dispersion ',flstr(1:2),' ',lvec{level},' ',seas_str(2:end)];
    filename = ['seasonal_disp_',flstr(1:2),'_both',num2str(level),seas_str];
elseif plot_in == 2
    legend(gh,'JJAS W LR','NDJFM W LR','JJAS W HR','NDJFM W HR','Location','Best')
    ylabel('m^2')
    ptitle = ['Absolute W Seasonal Dispersion ',flstr(1:2),' ',lvec{level},' ',seas_str(2:end)];
    filename = ['seasonal_disp_w_',flstr(1:2),'_both',num2str(level),seas_str];
end    
title(ptitle)
text_line(2)
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end
%end
