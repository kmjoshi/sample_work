function lag_spectra_seas(grdnum,f,level,seas)
%% Calculate lafrangian velocity spectra, with bandpass and significance
%  wavelets to assess seasonality?

if f == 1 & level > 1; return; end

disp([grdnum f level seas])

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
    npart = 6482;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    npart = 4980;
end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};

ttt = 1461; rr = length(timestrvec);

    
    uff = zeros(1025,1); vff = zeros(1025,1); wff = zeros(1025,1); 
    ufo = zeros(1025,1); vfo = zeros(1025,1); wfo = zeros(1025,1); 
    ndata = zeros(1025,1);
    
    
for r = 1:rr
%for r = 4;
    timestr = timestrvec{r};
    disp(timestr)
    
    try lag_field = lag_load(grdnum,f,r,level,seas_in,1,1,0,1);
    catch; continue; end
    
    u = lag_field.u - lag_field.useas; v = lag_field.v - lag_field.vseas; 
    w = lag_field.w - lag_field.wseas;
    
    lon = lag_field.lon; lat = lag_field.lat; 
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
    
    t_size = size(lag_field.lon,1);
    
    % seas selection code
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
    %

    tic;
    for p = 1:npart
        for i = 1:j
            se = sed(i); es = est(i);
            if grdnum == 1;
                in2 = find(lat(se:es,1,p) < -10,1,'first');
                if isempty(in2); continue;
                else se = in2; end
                in1 = find(lon(se:es,1,p) < -34,1,'first');
                if ~isempty(in1) && in1 + se <= t_size; es = se + in1; 
                else es = t_size; end
            end
            t_temp = find(isnan(sq(lon(se:es,1,p))) == 1,1,'first');
            if ~isempty(t_temp); tt = t_temp - 1; else tt = es-se+1; end
            if tt < 40; continue; end
            disp(['Particle ',num2str(p),' life = ',num2str(tt)])
            lim = es-se;
            %lim = find(isnan(lag_field.lon(:,1,p)) == 1,1,'first');
            %if isempty(lim); lim = tt;
            %else
        %    if lim < 120; continue; end
        %end
        [~,freq] = fftseries(1:npart,ttt);
        fin = find(freq<1/(lim+1),1,'last');
        ub = filtering1(sq(u(se:es,1,p)),grdnum,0);
        vb = filtering1(sq(v(se:es,1,p)),grdnum,0);
        wb = sq(w(se:es,1,p));
        h = ones(lim+1,1);%hann(lim+1);
        [uft,~] = fftseries(sq(ub).*h,ttt);
        [vft,~] = fftseries(sq(vb).*h,ttt);
        [wft,~] = fftseries(sq(wb).*h,ttt);
        uft(1:fin) = NaN; vft(1:fin) = NaN; wft(1:fin) = NaN;
        uff = nansum([uff,uft],2);
        vff = nansum([vff,vft],2);
        wff = nansum([wff,wft],2);
        %
        ndata(fin+1:end) = ndata(fin+1:end) + 1;
        % original data
        [ufp,~] = fftseries(sq(u(se:es,1,p)).*h,ttt);
        [vfp,~] = fftseries(sq(v(se:es,1,p)).*h,ttt);
        [wfp,~] = fftseries(sq(w(se:es,1,p)).*h,ttt);
        ufp(1:fin) = NaN; vfp(1:fin) = NaN; wfp(1:fin) = NaN;
        ufo = nansum([ufo,ufp],2);
        vfo = nansum([vfo,vfp],2);
        wfo = nansum([wfo,wfp],2);
        end
    end
    toc;
end

[~,freq] = fftseries(1:npart,ttt);

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/fft/';
filename = ['lag_spectra_seasf_',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
save([filepath,filename,'.mat'],'uff','vff','wff','ndata','freq','ufo','vfo','wfo')

end


function plotting()

for grdnum = [1,3]; for f = 1:2; for level = 1:4;

if f == 1 & level > 1; continue; end
            
flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};
seas_str = '';
    
lvec = {'15m' '30m' '60m' '150m'};
cvec = [0.65 0 0.13;0.164 0.043 0.85;0.97 0.43 0.37;0.25 0.63 1];

for seas = 1:2
    
if seas == 1
    s = 6:9; str = 'JJAS';
elseif seas == 2
    s = [11,12,1,2,3]; str = 'NDJFM';
end

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/fft/';
filename = ['lag_spectra_seasf_',str,'_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
load([filepath,filename])
%uff = uff./ndata;%trapz(freq,uff); 
%vff = vff./ndata;%trapz(freq,vff); 
%wff = wff./ndata;%trapz(freq,wff);
ufo = ufo./ndata;%trapz(freq,ufo); 
vfo = vfo./ndata;%trapz(freq,vfo); 
wfo = wfo./ndata;%trapz(freq,wfo);
%ufs = area_norm(freq,nanmean(uf,1));
%vfs = area_norm(freq,nanmean(vf,1));
%wfs = area_norm(freq,nanmean(wf,1));
x = 1./freq/4;

figure(1); 
%plot(x,uff,'Color',cvec(seas,:)); hold on
plot(x,ufo,'Color',cvec(seas,:))%,'Linestyle',':')
%legend('Filtered JJAS','Original JJAS','Filtered NDJFM','Original NDJFM','Location','Best')
legend('JJAS','NDJFM')
xlim([0.5,40]); grid on
set(gca,'xscale','log')
%plot_settings
%title(['U ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1)])
hold on

%figure(2); 
%plot(x,vff,'Color',cvec(seas,:)); hold on
plot(x,vfo,'Color',cvec(seas,:),'Linestyle','--')
%legend('Filtered JJAS','Original JJAS','Filtered NDJFM','Original NDJFM','Location','Best')
xlim([0.5,30]); grid on
set(gca,'xscale','log')
%plot_settings
title(['UV ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1)])
legend('JJAS U','JJAS V','NDJFM U','NDJFM V','Location','Best')

% figure(3); 
% plot(x,wff,'Color',cvec(seas,:))
% legend('JJAS','NDJFM','Location','Best')
% xlim([0.5,40]); grid on
% set(gca,'xscale','log')
% %plot_settings
% title(['W ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1)])
% hold on
%title(num2str([grdnum f level]))
end

filename = ['lag_spectra_seas_',flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];

figure(1)
export_fig(gcf,[filepath,'U_',filename,'.png'],'-m2','-r72','-q95','-transparent')
clf
figure(2)
export_fig(gcf,[filepath,'V_',filename,'.png'],'-m2','-r72','-q95','-transparent')
clf
% figure(3)
% export_fig(gcf,[filepath,'W_',filename,'.png'],'-m2','-r72','-q95','-transparent')
% clf
end; end; end

end

function plot_settings()
legend('Filtered Signal','Original Signal','Location','Best')
xlim([0.5,40]); grid minor
set(gca,'xscale','log')
end

function out = fft_norm(freq,ffs)
out = ffs/trapz(freq,ffs);
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