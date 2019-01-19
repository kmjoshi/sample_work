function rel_dispersion_seas(grdnum,f,level,seas)
%% Calculate relative dispersion of Lagrangian particles
% 

if f == 1 & level > 1; return; end

disp([grdnum f level])
HR_version = 1;

% Constants
dt = 0.25*24*3600; % timestep

seas_in = 0;
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
    if HR_version == 1
        timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
            '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
        ppp = 4980;
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
        ppp = 22376;
    end
    min_d = 3.3e3;
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

    dists = zeros(ppp,4,ttt); nlag = zeros(ppp,4,ttt);

for r = 1:rr
%for r = 2
    timestr = timestrvec{r};
    disp(timestr)
    
    try lag_field = lag_load(grdnum,f,r,level,seas_in,1,0,0,0);
    catch; continue; end
    
    lon = lag_field.lon; lat = lag_field.lat;
    u_prime = lag_field.u; v_prime = lag_field.v;
        
    pp = size(lon,3);
    t_size = size(lon,1);
    
    %seas code
    timevec = lag_field.datenum;
    [~,mo,~,~,~,~] = datevec(timevec);
    if seas == 1
        s = 6:9; str = 'JJAS';
    elseif seas == 2
        s = [11,12,1,2,3]; str = 'NDJFM';
    end
    t_end = find(sq(nanmean(isnan(lag_field.lon),3)) == 1,1,'first');
    if isempty(t_end); t_end = length(mo); end
    if ~any(s == mo(1)) & ~any(s == mo(t_end)) & t_end < 500; 
        disp('Release not in season'); continue; end
    
    %%
    %matlabpool(12)
    tic;
    for p1 = 1:pp
        disp(['p1 = ',num2str(p1)])
        do = sq(spheric_dist(lat(1,1,p1),lat(1,1,:),lon(1,1,p1),lon(1,1,:)));
        p2 = find(do<min_d & do>0); d1 = do(p2);
        d2 = sq(spheric_dist(lat(2,1,p1),lat(2,1,p2),lon(2,1,p1),lon(2,1,p2)));
        if isempty(p2); disp('no adjacent particles'); continue; end
        pl = length(p2);
        if pl > 4; disp('TOO MANY CLOSE PARTICLES ABORT!!!!'); 
        elseif pl < 4; d1(pl+1:4) = NaN; d2(pl+1:4) = NaN; end
        dists(p1,:,1) = d1; dists(p1,:,2) = d2;
        tic;
        t_temp1 = find(isnan(sq(lon(:,1,p1))) == 1,1,'first');
        if ~isempty(t_temp1); tt1 = t_temp1; else tt1 = t_size; end
        upt1 = sq(u_prime(:,1,p1)); vpt1 = sq(v_prime(:,1,p1));
        for pf = 1:length(p2)
            t_temp2 = find(isnan(sq(lon(:,1,p2(pf)))) == 1,1,'first');
            if ~isempty(t_temp2); tt2 = t_temp2; else tt2 = t_size; end
            tt = min(tt1,tt2);
            disp(['Lifetime = ',num2str(tt)])
            upt2 = sq(u_prime(:,1,p2(pf))); vpt2 = sq(v_prime(:,1,p2(pf)));
            for to = 3:tt
                if ~any(s == mo(to)); continue; end;
                if lon(to,1,p1) < -34 || lon(to,1,pf) < -34 || ...
                        lat(to,1,p1) > -10 || lat(to,1,pf) > -10
                    continue; 
                end
                dists(p1,pf,to) = dists(p1,pf,2) + ...
                    sqrt((sum(upt2(2:to-1) - upt1(2:to-1))*dt)^2 + ...
                    (sum(vpt2(to-1) + vpt1(to-1))*dt)^2);
                nlag(p1,pf,to) = nlag(p1,pf,to) + 1;
            end
        end
        toc;
    end
    %matlabpool close
    
end
if HR_version == 1
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/rel/';
elseif HR_version == 2
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_HR_stats/';
end
filename = ['2ps_',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
save([filepath,filename,'.mat'],'dists','nlag')
    
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
grdnum = 1; f = 1; level = 1; seas_in = 0;
dt = 0.25;
Lt = zeros(3,2,4); Lt(:,1,1) = [5.25,0,2.5]; Lt(1,2,:) = [6,6,7,12]; Lt(3,2,:) = [3,3,3,8];
dispm = 1/1000000; lagm = 1/4; dispm1 = 3600*24;
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
cvec = [0.65 0 0.13;0.164 0.043 0.85];
%if f == 1 & level > 1; continue; end
for seas = 1:2
    if seas == 1
        s = 6:9; str = 'JJAS';
    elseif seas == 2
        s = [11,12,1,2,3]; str = 'NDJFM';
    end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/rel/';
filename = ['2ps_',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename])

rdisp(1:2) = sq(nansum(nansum((dists(:,:,1:2)).^2,1),2)./(nansum(nansum(~isnan(dists(:,:,1:2)),1),2)));
rdisp(3:end) = sq(nansum(nansum((dists(:,:,3:end)).^2,1),2)./(nansum(nansum(nlag(:,:,3:end),1),2)));
nlagr = sq((nansum(nansum(nlag,1),2)));

    nstar = nlagr*(dt/(2*Lt(grdnum,f,level)));
    err = 1.96*rdisp.*sqrt(2./(nstar-1));

tend = find(nstar <= 100,1,'first');
%if isempty(tend); 
tend = length(nlagr); %end

lagvec = 0:length(nstar)-1;
x1 = lagvec(1:tend)*lagm;
%x2 = (lagvec(1:tend-1)+diff(lagvec(1:tend))/2)*lagm;
yp = (rdisp(1:tend)+err(1:tend))*dispm;
ym = (rdisp(1:tend)-err(1:tend))*dispm;
y = rdisp(1:tend)*dispm;
%y2 = diff(log10(rdisp(1:tend)*dispm))./diff(log10(lagvec(1:tend)*dt*dispm1));

figure;
h(seas) = plot(x1,y,'LineStyle','-','Color',cvec(seas,:)); hold on
plot(x1,yp,'LineStyle',':','Color',cvec(seas,:)); hold on
plot(x1,ym,'LineStyle',':','Color',cvec(seas,:)); hold on
end
xlim([0,60]);
xlabel('days')
ylabel('km^2')
ptitle = ['UV relative dispersion ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
set(gca,'xscale','linear','yscale','log')
legend(h,'JJAS','NDJFM','Location','Best')
text_line(1)
grid on

filename = ['relseasdisp_uv',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
% figure(2); clf
% plot(x2,yu2,'LineStyle','-','Color',[0.65 0 0.13]); hold on
% plot(x2,yv2,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
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