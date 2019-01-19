function tpart_stats(grdnum,f,level,seas_in,stat,varargin)
%% Calculate 2-particle statitics from rel_dispersion output
%
if f == 1 & level > 1; return; end

if nargin > 5
    ifw = varargin{1};
else ifw = 0; end

disp([grdnum f level])

% Constants
Lt = zeros(3,2,4); Lt(:,1,1) = [4.25,0,3]; Lt(1,2,:) = [5.5,6,6.75,11.25]; 
Lt(3,2,:) = [3,3,3.5,8];
dt = 0.25*24*3600; % timestep in seconds

% Setup
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
    grd = rnt_gridload('soatl1');
    [~,b,dx,dy] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
    max_d = floor(sqrt(sum(([dx,dy].*size(grd.h)).^2)));
    max_r = floor(max_d/min_d);
    ppp = 6482;
    %dskip = 3;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    grd = rnt_gridload('soatl3');
    [~,b,dx,dy] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
    max_d = floor(sqrt(sum(([dx,dy].*size(grd.h)).^2)));
    max_r = floor(max_d/min_d);
    ppp = 4980;
    %dskip = 3;
end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};
rr = length(timestrvec);

if ifw
    % IN CASE OF W
    min_d = 1; max_r = 100;
    % END
    wstr = 'w';
    wstr1 = '_w';
else wstr = '';
    wstr1 = '';
end

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
for r = 1:rr
    timestr = timestrvec{r};
    filename = ['2ps',wstr1,flstr(1:2),'_',timestr,'_',num2str(grdnum),num2str(level),seas_str];
    load([filepath,filename,'.mat'])

% Ignore the western boundary current as dynamically different from HR
% simulation, do this by using the mean flow field

switch upper(stat)
    case 'DISPERSION'
        % nanmean 1,2 combined and all releases
        rdisp(r,:) = nansum(nansum(dists.^2,1),2)./(nansum(nansum(nlag,1),2));
        nlagr(r,:) = (nansum(nansum(nlag,1),2));
        % dim (release,lag)
    case 'FSLE'
        % nanmean 2 then calc times for distance thresholds
        % get map for each release and average them to get curve
        do = min_d;
        to = zeros(ppp,4); tf = zeros(ppp,4);
        for i = 2:max_r
            df = do*i;
            %disp([num2str(df/1000),' km'])
            disp([num2str(df),' m'])
            for p1 = 1:size(dists,1)
                for p2 = 1:size(dists,2)
                    temp = find(abs(dists(p1,p2,:)) >= df,1,'first');
                    if isempty(temp); tf(p1,p2) = NaN;
                    elseif temp == size(dists,3); tf(p1,p2) = temp;
                    else
                        [~,alpha] = min(abs(abs(dists(p1,p2,temp-1:temp+1))-df));
                        temp = temp + alpha - 2;
                        tf(p1,p2) = temp; 
                        temp2 = find(abs(dists(p1,p2,1:tf(p1,p2))) <= do,1,'last');
                        if isempty(temp2) || temp2 == 1; to(p1,p2) = 1; 
                        else 
                        [~,alpha] = min(abs(abs(dists(p1,p2,temp2-1:temp2+1))-do));
                        temp2 = temp2 + alpha - 2;
                        to(p1,p2) = temp2; 
                        end
                    end
                end
            end
            fslep(r,i,:) = log(i)./nanmean(tf-to,2);
            ndist(r,i) = sum(isnan(nanmean(tf,2)));
        end
    case 'FTLE'
        % nanmean 2 then calc distances travelled from intial in
        % times decided upon and average over releases
        lagvec = (0:1460)*0.25*24*3600;
        ftlep(r,:,:) = sq(log(nansum(abs(dists),2)./nansum(nlag,2)/min_d))./repmat(lagvec,[ppp,1]);
        % dim (release, particle, time)
end
end

switch upper(stat)
    case 'DISPERSION'
        dispavg = nansum(rdisp.*nlagr,1)./nansum(nlagr,1);
        lagvec = 0:1:length(dispavg);
        nstar = nansum(nlagr,1)*dt/(2*Lt(grdnum,f,level));
        err = 1.96*dispavg.*sqrt(2./(nstar-1));
        filename = ['rel_disp_',wstr,flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
        save([filepath,filename,'.mat'],'rdisp','nstar','lagvec','dispavg','err')
    case 'FSLE'
        fsle = nansum(nansum(fslep,3),1)./nansum(ndist,1);
        dvec = 2:max_r;
        filename = ['fsle_',wstr,flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
        save([filepath,filename,'.mat'],'fslep','dvec','fsle')
    case 'FTLE'
        ftle = nansum(nansum(ftlep,1),2)./nansum(nanmean(nlag,2),1);
        filename = ['ftle_',wstr,flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
        save([filepath,filename,'.mat'],'ftlep','lagvec','ftle')
end

end

function plotting()

%% dispersion
grdnum = 1; f = 1; level = 1; seas_in = 0;
dt = 0.25;
Lt = zeros(3,2,4); Lt(:,1,1) = [4.25,0,3]; Lt(1,2,:) = [5.5,6,6.75,11.25]; Lt(3,2,:) = [3,3,3.5,8];
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
dispm = 1; lagm = 1/4; dispm1 = (3600*24)^2;

for f = 1:2
if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['rel_disp_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'dispavg','lagvec','err','nstar')

tend = find(nstar <= 100,3,'first');
if isempty(tend); tend = length(nstar); 
else tend = tend(3); end

x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yp = (dispavg(1:tend)+err(1:tend))*dispm;
ym = (dispavg(1:tend)-err(1:tend))*dispm;
y  = dispavg(1:tend);
y2 = diff(log10(dispavg(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm1)));

figure(1); clf
plot(x1,y,'b',x1,yp,':b',x1,ym,':b')

xlim([0,tend*lagm]);
xlabel('days')
ylabel('km^2')
%legend('u','u 95% CI','v','v 95% CI','Location','SouthEast')
ptitle = ['Relative Dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
set(gca,'xscale','linear','yscale','log')
grid on
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

figure(2); clf
y2 = smooth(y2,7);
plot(x2,y2,'b')
xlim([0,tend*lagm]);
ylim([0,3]);
xlabel('days')
%legend('u','v','Location','NorthWest')
ptitle = ['relative dispersion slope ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
set(gca,'xscale','linear','yscale','linear')
grid minor
filename = ['reldisp_slope_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end

%% FSLE
% curves
grdnum = 1; f = 1; level = 1; seas_in = 0;
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

if grdnum == 1;
    grd = rnt_gridload('soatl1');
    [~,b,~,~] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
elseif grdnum == 3;
    grd = rnt_gridload('soatl3');
    [~,b,~,~] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
end

for f = 1:2
if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['fsle_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'fsle','dvec')

figure(1); clf
x1 = dvec*min_d/1000;
y1 = fsle(2:end);
plot(x1,y1);

%xlim([0,tend*lagm]);
xlabel('\bf{\delta} (km)')
ylabel('\bf{\lambda(\delta)}')
ptitle = ['FSLE ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
set(gca,'xscale','log','yscale','log')
grid on
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

figure(2); clf
y2 = diff(log10(y1))./diff(log10(x1));
x2 = (x1(1:end-1)+diff(x1(1:end))/2);
plot(x2,y2,'b')
xlabel('\bf{\delta} (km)')
ylabel('\bf{d\lambda/d\delta}')
ptitle = ['fsle slope ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
set(gca,'xscale','linear','yscale','linear')
grid minor
filename = ['fsle_slope_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end

%% FTLE
%curves
grdnum = 1; f = 1; level = 1; seas_in = 0;
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

for f = 1:2
if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['ftle_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'ftle','lagvec')

figure(1); clf
x1 = lagvec;
y1 = sq(ftle)';
plot(x1,y1);

%xlim([0,tend*lagm]);
xlabel('\bf{\delta} (s)')
ylabel('\bf{\lambda(\delta)}')
ptitle = ['ftle ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
set(gca,'xscale','log','yscale','log')
grid on
ylim([10^-6,10^-4])
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

% figure(2); clf
% y2 = diff(log10(y1))./diff(log10(x1));
% x2 = (x1(1:end-1)+diff(x1(1:end))/2);
% plot(x2,y2,'b')
% xlabel('\bf{\delta} (s)')
% ylabel('\bf{d\lambda/d\delta}')
% ptitle = ['ftle slope ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
% title(ptitle)
% text_line(1)
% set(gca,'xscale','linear','yscale','linear')
% grid minor
% filename = ['ftle_slope_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
% export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end
end

function plotting_maps()

%% FTLE
grdnum = 1; f = 1; level = 1; seas_in = 0;
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

tprime = 1; % in days
tsel = tprime*4;
load('/atlas2/kjoshi36/LANL/lagrangian_data/lonlat.mat') 

for f = 1:2
if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['ftle_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
%load([filepath,filename,'.mat'],'ftle','lagvec')
ftlemat = matfile([filepath,filename,'.mat']);
ftlep = nanmean(ftlemat.ftlep(:,:,tsel),1);

figure;
scatter(lon,lat,20,ftlep,'filled')
axis equal
axis tight
hold on
world_coast
colorbar('EastOutside');
caxis([0,0.75e-5])
%xlim([lonmin,lonmax]); ylim([latmin,latmax]);
ptitle = ['FTLE ',num2str(tprime),' days ',flstr(1:2),' ',lvec{level},' ',...
    cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(2,[0.65,0.5,0.4])

end


%% FSLE



end