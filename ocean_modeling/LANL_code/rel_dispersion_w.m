function rel_dispersion_w(grdnum,f,level,seas_in)
%% Calculate relative dispersion of Lagrangian particles
% 

if f == 1 & level > 1; return; end

disp([grdnum f level])

% Constants
Lt = zeros(3,2,4); Lt(:,1,1) = [4.5,0,2.5]; Lt(1,2,:) = [6,6,7,12]; Lt(3,2,:) = [3,3,3,8];
dt = 0.25*24*3600; % timestep

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
    min_d = 30e3;
    ppp = 6482;
    %dskip = 3;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    min_d = 3.3e3;
    ppp = 4980;
    %dskip = 3;
end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};

ttt = 1461; rr = length(timestrvec);

%[~,~,dx,dy] = ct_misc_mean_grid_spacing(grd);
%dlx = nanmean(diff(grd.lonr(:,1)));
%dly = nanmean(diff(grd.latr(1,:)));
%dlmx = max(diff(grd.lonr(:,1)));
%dlmy = max(diff(grd.latr(1,:)));

for r = 1:rr
    timestr = timestrvec{r};
    disp(timestr)
    
    try lag_field = lag_load(grdnum,f,r,level,seas_in,0,1,0,0);
    catch; continue; end
    
    lon = lag_field.lon; lat = lag_field.lat;
    z =lag_field.z;
    w_prime = lag_field.w;
        
    pp = size(lon,3);
    t_size = size(lon,1);
    
    dists = zeros(ppp,4,ttt); nlag = zeros(ppp,4,ttt);
    %%
    %matlabpool(12)
    tic;
    for p1 = 1:pp
        %disp(['p1 = ',num2str(p1)])
        do = sq(spheric_dist(lat(1,1,p1),lat(1,1,:),lon(1,1,p1),lon(1,1,:)));
        p2 = find(do<min_d & do>0); 
        d1 = sq(z(1,1,p1)-z(1,1,p2));
        d2 = sq(z(2,1,p1)-z(2,1,p2));
        %sq(spheric_dist(lat(2,1,p1),lat(2,1,p2),lon(2,1,p1),lon(2,1,p2)));
        if isempty(p2); disp('no adjacent particles'); continue; end
        pl = length(p2);
        if pl > 4; disp('TOO MANY CLOSE PARTICLES ABORT!!!!'); 
        elseif pl < 4; d1(pl+1:4) = NaN; d2(pl+1:4) = NaN; end
        dists(p1,:,1) = d1; dists(p1,:,2) = d2;
        %tic;
        t_temp1 = find(isnan(sq(lon(:,1,p1))) == 1,1,'first');
        if ~isempty(t_temp1); tt1 = t_temp1; else tt1 = t_size; end
        wpt1 = sq(w_prime(:,1,p1));
        for pf = 1:length(p2)
            t_temp2 = find(isnan(sq(lon(:,1,p2(pf)))) == 1,1,'first');
            if ~isempty(t_temp2); tt2 = t_temp2; else tt2 = t_size; end
            tt = min(tt1,tt2);
            %disp(['Lifetime = ',num2str(tt)])
            wpt2 = sq(w_prime(:,1,p2(pf)));
            for to = 3:tt
                dists(p1,pf,to) = dists(p1,pf,2) + sum(wpt2(2:to-1) - wpt1(2:to-1))*dt;
                nlag(p1,pf,to) = nlag(p1,pf,to) + 1;
            end            
        end
        %toc;
    end
    toc;
    %matlabpool close
    
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
    filename = ['2ps_w',flstr(1:2),'_',timestr,'_',num2str(grdnum),num2str(level),seas_str];
    save([filepath,filename,'.mat'],'dists','nlag') 
end

% dispuu = dispu./nlag*dt^2;
% dispvv = dispv./nlag*dt^2;
% nstar = nlag*(dt/(2*Lt(grdnum,f,level)));
% erru = 1.96*dispuu.*sqrt(2./(nstar-1));
% errv = 1.96*dispvv.*sqrt(2./(nstar-1));
% lagvec = 0:1:length(nstar)-1;
% 
% filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/dispersion/';
% filename = ['reldisp_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
% save([filepath,filename,'.mat'],'dispuu','dispvv','nlag','lagvec','erru','errv')
end

function d = distll(l1,l2)
d = (l2-l1)^2;
end

function [dispu, dispv, ndata] = rel_loop(p1,tt1,t_size,lond,latd)
ttt = 1461;
dispu = zeros(ttt,1); dispv = zeros(ttt,1); ndata = zeros(ttt,1);
for p2 = p1:bla
    t_temp2 = find(isnan(sq(lond(:,1,p2))) == 1,1,'first');
    if ~isempty(t_temp2); tt2 = t_temp2; else tt2 = t_size; end
    tt = min(tt1,tt2);
    for to = 1:tt
        dispu(to) = dispu(to) + distll(lond(to,1,p1),lond(to,1,p2));
        dispv(to) = dispu(to) + distll(latd(to,1,p1),latd(to,1,p2));
        ndata(to) = ndata(to) + 1;
    end
    
end
end


function plotting()
grdnum = 3; f = 1; level = 1; seas_in = 0; iferror = 0; ifclean = 0;
dt = 0.25;
Lt = zeros(3,2,4); Lt(:,1,1) = [7,0,3]; Lt(1,2,:) = [7,7,7,12]; Lt(3,2,:) = [3,3,3.5,8];
dispm = (3600*24)^2; lagm = 1/4; %6*3600;
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
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/dispersion/';
filename = ['reldisp_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename],'dispuu','dispvv','lagvec','erru','errv','nlag')

if ifclean
    nstar = nlag*(dt/(2*Lt(grdnum,f,level)));
    nstar = [2,nstar'];
    erru = 1.96*dispuu.*sqrt(2./(nstar-1));
    errv = 1.96*dispvv.*sqrt(2./(nstar-1));
    save([filepath,filename,'.mat'],'erru','errv','-append')
end

nstar = nlag*(dt/(2*Lt(grdnum,f,level)));
tend = find(nstar <= 100,1,'first');
if isempty(tend); tend = length(nlag); end

x1 = lagvec(1:tend)*lagm;
x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yup = (dispuu(1:tend)+erru(1:tend))*dispm;
yum = (dispuu(1:tend)-erru(1:tend))*dispm;
yu = dispuu(1:tend)*dispm;
yvp = (dispvv(1:tend)+errv(1:tend))*dispm;
yvm = (dispvv(1:tend)-errv(1:tend))*dispm;
yv = dispvv(1:tend)*dispm;
yu2 = diff(log10(dispuu(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));
yv2 = diff(log10(dispvv(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*sqrt(dispm)));

figure(1); clf
plot(x1,yu,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,yv,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
plot(x1,yup,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,yvp,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on
plot(x1,yum,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,yvm,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on

xlim([0,tend*lagm]);
xlabel('days')
ylabel('km^2')
ptitle = ['UV relative dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
legend('u','v','Location','Best')
text_line(1)
grid on

filename = ['reldisp_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')

figure(2); clf
plot(x2,yu2,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x2,yv2,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
xlim([0,tend*lagm]);
ylim('auto');
xlabel('days')
legend('u','v','Location','Best')
ptitle = ['UV relative dispersion slope ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(2)
set(gca,'xscale','linear','yscale','linear')
grid minor
filename = ['reldisp_slope_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end