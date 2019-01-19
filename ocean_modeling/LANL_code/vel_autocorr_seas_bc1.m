function vel_autocorr_seas_bc1(grdnum,f,level,seas)
%% Calculate velocity autocorrelation of Lagrangian particles
% Specifically for 10 days

if f == 1 & level > 1; return; end

disp([grdnum f level])
seas_in = 0;

% constants

Lt = [6,6,6,10]; % lagrangian timescale from the integral of the velocity autocorrelation
dt = 0.25; % timestep

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
    npart = 6482;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    npart = 4980;
end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};
ttt = 1461; rr = length(timestrvec);

acu = zeros(ttt-2,npart,rr); acv = zeros(ttt-2,npart,rr);
ndata = zeros(ttt-2,npart,rr);

for r = 1:length(timestrvec)
%for r = 10
    timestr = timestrvec{r};
    disp(timestr)
        
    % relative from interp
    try lag_field = lag_load(grdnum,f,r,level,seas_in,1,0,0,1);
    catch; continue; end,
    
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
    
    if seas 
        u_prime = lag_field.u - lag_field.useas;
        v_prime = lag_field.v - lag_field.vseas;
    else
        u_prime = lag_field.u - lag_field.umean;
        v_prime = lag_field.v - lag_field.vmean;
        str = '';
    end
    %u = lag_field.u; v = lag_field.v;
    
    pp = size(lag_field.lon,3);
    t_size = size(lag_field.lon,1);
    
    lon = lag_field.lon;
    lat = lag_field.lat;
    %
    
    acur = zeros(ttt-2,npart); acvr = zeros(ttt-2,npart);
    acut = zeros(ttt-2,1); acvt = zeros(ttt-2,1);
    ndatat = zeros(ttt-2,1);
    ndatar = zeros(ttt-2,npart);
    
    if grdnum == 1 && seas == 1
        if r == 1
            sed(1) = 1;
            est(1) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'first');
            sed(2) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'last');
            est(2) = t_size;
            j = 2;
        elseif r == 2 || r == 3
            sed(1) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'last');
            est(1) = t_size;
            j = 1;
        elseif r == 4
            sed(1) = 1; est(1) = t_size;
            j = 1;
        end
    else
        for i = 1:length(s)
            st = find(mo == s(i),1,'first');
            if ~isempty(st); start(i) = st; else start(i) = t_size; end
        end
        sed = min(start);
        if seas == 2 && grdnum == 1
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4) & mo ~= s(5),1,'first');
        elseif seas == 1 && r < 4;
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'first');
        elseif seas == 2 && r >= 4;
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4) & mo ~= s(5)...
                ,1,'first');
        else
            est = t_size;
        end
        j = 1;
    end
    
    matlabpool(12)
    tic;
    parfor p = 1:pp
        %disp(p)
        %upt = sq(u_prime(:,1,p)); vpt = sq(v_prime(:,1,p));
        for i = 1:j
            se = sed(i); es = est(i); 
        t_temp = find(isnan(sq(lon(se:es,1,p))) == 1,1,'first');
        if ~isempty(t_temp); tt = t_temp - 1; else tt = es-se+1; end %t_size; end
        disp(['Particle ',num2str(p),' life = ',num2str(tt)])
        if tt < 40; continue; end
        ub = filtering1(sq(u_prime(se:es,1,p)),grdnum,0);
        vb = filtering1(sq(v_prime(se:es,1,p)),grdnum,0);
        [acut,acvt,ndatat] = calc_autocorr(ub,vb,tt,mo(se:es),s,...
            lon(se:es,1,p),lat(se:es,1,p));
        acur(:,p) = acur(:,p) + acut;
        acvr(:,p) = acvr(:,p) + acvt;
        ndatar(:,p) = ndatar(:,p) + ndatat;
        end
    end
    acu(:,:,r) = acur; acv(:,:,r) = acvr; ndata(:,:,r) = ndatar;
    toc;
    matlabpool close
end

nlag = nansum(nansum(ndata,3),2);
acuu = nansum(nansum(acu,3),2)./nlag;
acvv = nansum(nansum(acv,3),2)./nlag;

%disp(nind-nstar)
nstar = nlag*(dt/(2*Lt(level)));
erru = 1.96*acuu.*sqrt(2./(nstar-1));
errv = 1.96*acvv.*sqrt(2./(nstar-1));
      
lagvec = 0:1:length(nstar)-1;

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/';
filename = ['uvautocorr_bc_10day',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
save([filepath,filename,'.mat'],'acuu','acvv','nlag','lagvec',...
    'erru','errv','acu','acv')

% transform latlon to metres to calculate absolute dispersion using
% displacement

end

function [acu,acv,ndata] = calc_autocorr(upt,vpt,tt,mo,s,lont,latt)
%calc_disp(p,r,upt,vpt,acu,acv,ndata,tt,t_temp,lag_field.lon)
ttt = 1461;
acu = zeros(ttt-2,1); acv = zeros(ttt-2,1); ndata = zeros(ttt-2,1);

if tt > 2;
    for to = 2:tt-1
        if ~any(s == mo(to)); continue; end;
        if lont(to) < -34; continue; end
        if latt(to) > -10; continue; end
        %disp(to)
        for tf = to:tt-1
            if ~any(s == mo(tf)); continue; end;
            if lont(tf) < -34; continue; end
            if latt(tf) > -10; continue; end
            %                 if ~isempty(t_temp) & isnan(lag_field.lon(tf+1,1,p));
            %                     break; end
            lag = tf - to + 1;
            % dispersion as a function of lag, p = particle,
            % r = release
            %[acu,acv,ndata] = calc_disp(upt,vpt,to,tf,lag,p,r,acu,acv,ndata);
            acu(lag) = acu(lag) + upt(to)*upt(tf);
            acv(lag) = acv(lag) + vpt(to)*vpt(tf);
            ndata(lag) = ndata(lag) + 1;
        end
    end
end
end

function y = filtering1(u,grdnum,speccheck)

if grdnum == 3
d = fdesign.lowpass('Fp,Fst',1/2.33/2,1/2.3/2);
Hd = design(d,'cheby2');
ylo = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);

d = fdesign.highpass('Fst,Fp',1/1.93/2,1/1.9/2);
Hd = design(d,'cheby2');
yhi = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);

y = ylo+yhi;
elseif grdnum == 1
d = fdesign.lowpass('Fp,Fst',1/3.6/2,1/3.5/2);
Hd = design(d,'cheby2');
y = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);
end

if speccheck
    [ffn,frn] = fftseries(y,length(y));
    [ffo,fro] = fftseries(u,length(u));
    figure(3); clf
    plot(1./fro/4,ffo)
    hold on
    plot(1./frn/4,ffn,'r')
    legend('Original Signal','Bandpass Signal')
    xlim([0.5,40])
    set(gca,'xscale','log')
    grid on
end
end

function plotting()

grdnum = 1; f = 1; level = 1; seas_in = 0; ifclean = 1;
seas = 1;

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

if seas == 1
        s = 6:9; str = 'JJAS';
    elseif seas == 2
        s = [11,12,1,2,3]; str = 'NDJFM';
end

%if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/';
filename = ['uvautocorr_bc_10day',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'acuu','acvv','lagvec','erru','errv','nlag')

disp([grdnum f level])

if ifclean
    %erru = 1.96*acuu.*sqrt(2./(nlag-1));
    %errv = 1.96*acvv.*sqrt(2./(nlag-1));
    Lt_u = find(acuu <= acuu(1)*exp(-1),1,'first')/4
    Lt_v = find(acvv <= acvv(1)*exp(-1),1,'first')/4
    nstar = nlag*0.25/(2*mean([Lt_u,Lt_v]));
    err = 2*acuu(1).*sqrt(1./(nstar-1));
    %save([filepath,filename,'.mat'],'Lt_u','Lt_v','-append')
end

%tend = find(nstar <= 200,1,'first');
%if isempty(tend); 
tend = length(nstar)-1; % end

figure
plot(lagvec(1:tend)/4,acuu(1:tend)/acuu(1),'r',...
    lagvec(1:tend)/4,acvv(1:tend)/acvv(1),'b',...
    lagvec(1:tend)/4,(err(1:tend))/acuu(1),':k',...
    lagvec(1:tend)/4,(-err(1:tend))/acuu(1),':k')
line(0:tend/4,zeros(1,tend/4+1),'Color','k');

xlim([0,60]); ylim([-0.2,1])
xlabel('days')
%legend('u','u 95% CI','v','v 95% CI')
legend('u','v')
ptitle = ['UV ',str,' autocorrelation ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)
grid minor

export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end

function plotting2()
%% plot all the auto-correlations 
grdnum = 1; f = 1; level = 1; seas_in = 0; ifplot = 1; iferror = 1; ifclean = 0;
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
Lt = zeros(3,2,4); Lt(:,1,1) = [6,0,3]; Lt(1,2,:) = [6,6,6,10]; Lt(3,2,:) = [3,3,3,7];
dt = 0.25; % timestep

%if f == 1 & level > 1; continue; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/dispersion/';

% interp
filename = ['uvautocorr_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'acuu','acvv','lagvec','erru','errv','nlag')

nstar = nlag*dt/(2*Lt(grdnum,f,level));
erru = 1.96*acuu.*sqrt(2./(nstar-1));
errv = 1.96*acvv.*sqrt(2./(nstar-1));

tend = find(nlag <= 200,1,'first');
if isempty(tend); tend = length(nlag); end

x2 = lagvec(1:tend)/4;
acu2 = acuu(1:tend)/acuu(1);
acv2 = acvv(1:tend)/acvv(1);
acup2 = (acuu(1:tend)+erru(1:tend))/acuu(1);
acum2 = (acuu(1:tend)-erru(1:tend))/acuu(1);
acvp2 = (acvv(1:tend)+errv(1:tend))/acvv(1);
acvm2 = (acvv(1:tend)-errv(1:tend))/acvv(1);

% absolute
filename = ['uvautocorr_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,'abs/',filename,'.mat'],'acuu','acvv','lagvec','erru','errv','nlag')

nstar = nlag*dt/(2*Lt(grdnum,f,level));
erru = 1.96*acuu.*sqrt(2./(nstar-1));
errv = 1.96*acvv.*sqrt(2./(nstar-1));

tend = find(nlag <= 200,1,'first');
if isempty(tend); tend = length(nlag); end

x1 = lagvec(1:tend)/4;
acu1 = acuu(1:tend)/acuu(1);
acv1 = acvv(1:tend)/acvv(1);
acup1 = (acuu(1:tend)+erru(1:tend))/acuu(1);
acum1 = (acuu(1:tend)-erru(1:tend))/acuu(1);
acvp1 = (acvv(1:tend)+errv(1:tend))/acvv(1);
acvm1 = (acvv(1:tend)-errv(1:tend))/acvv(1);

% binned
filename = ['uvautocorr_bin_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename,'.mat'],'acuu','acvv','lagvec','erru','errv','nlag')

nstar = nlag*dt/(2*Lt(grdnum,f,level));
erru = 1.96*acuu.*sqrt(2./(nstar-1));
errv = 1.96*acvv.*sqrt(2./(nstar-1));

tend = find(nlag <= 200,1,'first');
if isempty(tend); tend = length(nlag); end

x3 = lagvec(1:tend)/4;
acu3 = acuu(1:tend)/acuu(1);
acv3 = acvv(1:tend)/acvv(1);
acup3 = (acuu(1:tend)+erru(1:tend))/acuu(1);
acum3 = (acuu(1:tend)-erru(1:tend))/acuu(1);
acvp3 = (acvv(1:tend)+errv(1:tend))/acvv(1);
acvm3 = (acvv(1:tend)-errv(1:tend))/acvv(1);

% plot
figure(1); clf
plot(x1,acu1,'LineStyle','-','Color',[0.65 0 0.13]); hold on
plot(x1,acv1,'LineStyle','-','Color',[0.164 0.043 0.85]); hold on
plot(x2,acu2,'LineStyle','-','Color',[0.97 0.43 0.37]); hold on
plot(x2,acv2,'LineStyle','-','Color',[0.25 0.63 1]); hold on
plot(x3,acu3,'LineStyle','-','Color',[1 0.88 0.6]); hold on
plot(x3,acv3,'LineStyle','-','Color',[0.67 0.973 1]); hold on
plot(x1,acup1,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,acvp1,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on
plot(x2,acup2,'LineStyle',':','Color',[0.97 0.43 0.37]); hold on
plot(x2,acvp2,'LineStyle',':','Color',[0.25 0.63 1]); hold on
plot(x3,acup3,'LineStyle',':','Color',[1 0.88 0.6]); hold on
plot(x3,acvp3,'LineStyle',':','Color',[0.67 0.973 1]); hold on
plot(x1,acum1,'LineStyle',':','Color',[0.65 0 0.13]); hold on
plot(x1,acvm1,'LineStyle',':','Color',[0.164 0.043 0.85]); hold on
plot(x2,acum2,'LineStyle',':','Color',[0.97 0.43 0.37]); hold on
plot(x2,acvm2,'LineStyle',':','Color',[0.25 0.63 1]); hold on
plot(x3,acum3,'LineStyle',':','Color',[1 0.88 0.6]); hold on
plot(x3,acvm3,'LineStyle',':','Color',[0.67 0.973 1]); hold on

xlim([0,tend/4]); ylim([-0.2,1])
xlabel('days')
%legend('u','u 95% CI','v','v 95% CI')
legend('u absolute','v absolute','u relative interp','v relative interp',...
    'u relative binned','v relative binned')
ptitle = ['UV autocorrelation ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
title(ptitle)
text_line(1)

filename = ['all_uvautocorr_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end