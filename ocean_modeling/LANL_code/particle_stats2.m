function particle_stats2(f,level)
%% Calculate miscellanous particle statistics
%   particles  in domain vs time
%   avg particle depth vs time
%   PDF depth
%   PDF particle lifetime
%

if f == 1 && level > 1
    return;
end

seas_in = 0;
grdnum = 3;

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_HR_stats/';

tl = 73;

pdfz_vec = [];

% timevec = zeros(tl,1461);

%for t = 1:tl
for t = 1:26
    disp(['Release ',num2str(t),' Level ',num2str(level)])
    tic;
    try lag_field = lag_load2(grdnum,f,t,level,seas_in);
    catch; end
    
    lon = lag_field.lon;
    lat = lag_field.lat;
    z = lag_field.z;
    timevec{t} = lag_field.datenum;
    
    for i = 1:size(lon,1)
        npart(t,i) = sum(sq(~isnan(lon(i,1,:))));
        if f == 2
        zpart(t,i) = mean(sq(z(i,1,~isnan(lon(i,1,:)))));
        pdfz = sq(z(i,1,~isnan(lon(i,1,:))));
        pdfz_vec = cat(1,pdfz_vec,pdfz);
        end
    end
    
    parfor p = 1:size(lon,3)
        if isempty(find(isnan(sq(lon(:,1,p))),1))
            plife(t,p) = size(lon,1);
        else plife(t,p) = find(isnan(sq(lon(:,1,p))),1) - 1;
        end
    end
    toc;
end

if seas_in == 0; seas_str = '';
else str = monthstr(seas_in); seas_str = ['_',str(:,1)']; end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};

filename = ['p_stats',flstr,'_',num2str(grdnum),num2str(level),seas_str];
if f == 1
    save([filepath,filename,'.mat'],'plife','npart','timevec')
elseif f == 2
    save([filepath,filename,'.mat'],'plife','npart','timevec','zpart','pdfz_vec')
end
end

function plotting()
%% Setup 
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_HR_stats/';
seas_str = '';
flstrvec = {'2d_z15m' '3d'};
lvec = {'15m' '30m' '60m' '150m'};

for grdnum = [1,3]
    if grdnum == 1; str = cpstr(1,1);
    else str = cpstr(0,1); end
    for f = 1:2
        for level = 1:4
            if f == 1 && level > 1
            continue; end
            flstr = flstrvec{f};
            filename = ['p_stats',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            load([filepath,filename])
            
%% 2d
% npart (release,time)
% plife (release,particle)
cmap = hsv(length(timevec));          
figure;
for t = 1:length(timevec)
    plot(timevec{t},npart(t,1:length(timevec{t})),'LineWidth',2,'Color',cmap(t,:))
    hold on;
end

%timevec{2},npart(2,1:length(timevec{2})),...
%    timevec{3},npart(3,1:length(timevec{3})),timevec{4},npart(4,1:length(timevec{4})));

datetick
tname = ['Particles in Domain ',flstr(1:2),' ',lvec{level},' ',str];
title(tname)
export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')

pmax = max(plife,[],2);
for i = 1:length(pmax)
plife(i,(plife(i,:) == pmax(i,:))) = NaN;
end
bins = linspace(0,365,36);
[data,bindata] = hist(plife(:)/4,bins);
%figure;
%plot(bindata,data); xlabel('days')
%tname = ['Particle Lifetime ',flstr(1:2),' ',lvec{level},' ',str];
%title(tname)
%export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')
plifetime.data = data;
plifetime.bindata = bindata;
save([filepath,filename],'plifetime','-append')

if f == 2
%% 3d
% zpart (release,time)
% pdfzvec (all depths)

figure;
for t = 1:length(timevec)
    tlim = find(npart(t,:) <= 200,1,'first'); 
    if tlim > length(timevec{t}); tlim = length(timevec{t}); end
    %plot(timevec{t},zpart(t,1:length(timevec{t})),'LineWidth',2,'Color',cmap(t,:))
    plot(timevec{t}(1:tlim),zpart(t,1:tlim),'LineWidth',2,'Color',cmap(t,:))
    hold on
end

%timevec{2},zpart(2,1:length(timevec{2})),...
%    timevec{3},zpart(3,1:length(timevec{3})),timevec{4},zpart(4,1:length(timevec{4})));

datetick
tname = ['Average Depth ',flstr(1:2),' ',lvec{level},' ',str];
title(tname)
text_line(2)
export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')

if level == 4
    bins = linspace(0,800,80);
else
    bins = linspace(0,500,50);
end
[data,bindata] = hist(-pdfz_vec(:),bins);
%figure; plot(bindata,data); xlabel('depth (m)')
%tname = ['Depth ',flstr(1:2),' ',lvec{level},' ',str];
%title(tname)
%export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')
pdfdepth.data = data;
pdfdepth.bindata = bindata;
save([filepath,filename],'pdfdepth','-append')

end

        end
    end
end
end

%% load all files to plot together
function plotting2()
%% Setup 
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/analysis/';
seas_str = '';
flstrvec = {'2d_z15m' '3d'};
lvec = {'15m' '30m' '60m' '150m'};
cmap = hsv(length(lvec));

for grdnum = [1]
    if grdnum == 1; str = cpstr(1,1);
    else str = cpstr(0,1); end
    for f = 2
        for level = 1:4
            if f == 1 && level > 1
            continue; end
            flstr = flstrvec{f};
            filename = ['p_stats',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            load([filepath,filename],'plifetime','pdfdepth')
            
figure(1); 
data = plifetime.data/sum(plifetime.data(:));
plot(plifetime.bindata,data,'Color',cmap(level,:)); xlabel('days')
hold on

if f == 2
    data = pdfdepth.data/sum(pdfdepth.data(:));
figure(2); plot(pdfdepth.bindata,data,'Color',cmap(level,:)); xlabel('depth (m)')
hold on
end
        end
    end
end

figure(1)
tname = ['Particle Lifetime ',flstr(1:2),' ',str];
legend(lvec(1:4))
xlim([0,150])
title(tname)
text_line(2)
export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')

figure(2);
tname = ['Depth ',flstr(1:2),' ',str];
legend(lvec(1:4))
xlim([0,250])
title(tname)
text_line(2)
export_fig(gcf,[filepath,strrep(tname,' ','_'),'.png'],'-m2','-r72','-q95','-transparent')





end