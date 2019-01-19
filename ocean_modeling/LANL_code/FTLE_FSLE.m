function numnum = FTLE_FSLE(grdnum,f,r,level,seas_in,le,le_num,varargin)
%% PLOT FTLE/FSLE maps
%
ifsave = 0;
iffig = 0; ifcol = 0; ifunique = 0; 
ifw = 0;

if ifw == 1
    wstr = 'w';
else wstr = '';
end

try iftitle = varargin{1};
catch; iftitle = 1; 
end

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

load(['/atlas2/kjoshi36/LANL/lagrangian_data/lonlat',num2str(grdnum),'.mat'])

switch upper(le)
    case 'FTLE'
%% FTLE
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
end
tprime = le_num; % in days
tsel = tprime*4;

if f == 1 & level > 1; disp('2D RUN'); return; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['ftle_',wstr,flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
%load([filepath,filename,'.mat'],'ftle','lagvec')
ftlemat = matfile([filepath,filename,'.mat']);
if r == 0;
    ftlep = nanmean(ftlemat.ftlep(:,:,tsel),1);
    timestr = 'avg';
else
    ftlep = ftlemat.ftlep(r,:,tsel);
    timestr = timestrvec{r};
end

field = ftlep;
ptitle = ['FTLE ',wstr,num2str(tprime),' days ',flstr(1:2),' ',lvec{level},' ',...
    cpstr(grdnum,1),' ',timestr,' ',seas_str(2:end)];
plot_settings(lon,lat,field,ptitle,iffig,ifcol,iftitle,ifunique,[flstr(1:2),' ',lvec{level}])

if ifsave 
    filename = ['ftle_',wstr,num2str(tprime),'d_',flstr(1:2),'_',timestr,'_',...
    num2str(grdnum),num2str(level),seas_str];
export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end

numnum = tprime;

    case 'FSLE'
%% FSLE
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    grd = rnt_gridload('soatl1');
    [~,b,~,~] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    grd = rnt_gridload('soatl3');
    [~,b,~,~] = ct_misc_mean_grid_spacing(grd);
    min_d = b*3;
end

if ifw
    dsel = le_num; % in m
else
dprime = le_num*1000; % in km
dsel = round(dprime/min_d);
end

if f == 1 & level > 1; disp('2D RUN'); return; end
flstr = flstrvec{f};
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/2particle_stats/';
filename = ['fsle_',wstr,flstr(1:2),'_',num2str(grdnum),num2str(level),seas_str];
%load([filepath,filename,'.mat'],'ftle','lagvec')
fslemat = matfile([filepath,filename,'.mat']);
if r == 0;
    fslep = nanmean(fslemat.fslep(:,dsel,:),1);
    timestr = 'avg';
else
    fslep = fslemat.fslep(r,dsel,:);
    timestr = timestrvec{r};
end

field = fslep;
if ifw
    ptitle = ['FSLE ',wstr,' ',num2str(dsel),'m ',flstr(1:2),' ',lvec{level},' ',...
    cpstr(grdnum,1),' ',timestr,' ',seas_str(2:end)];
else
    ptitle = ['FSLE ',wstr,num2str(round(dsel*min_d/1000)),' km ',flstr(1:2),' ',lvec{level},' ',...
    cpstr(grdnum,1),' ',timestr,' ',seas_str(2:end)];
end
plot_settings(lon,lat,field,ptitle,iffig,ifcol,iftitle,ifunique,[flstr(1:2),' ',lvec{level}])
% %figure;
% scatter(lon,lat,20,fslep,'filled')
% axis equal
% axis tight
% hold on
% world_coast
% colorbar('EastOutside');
% fm = nanmean(fslep(:)); fs = nanstd(fslep(:));
% cmin = fm-2*fs; cmax = fm+2*fs;
% caxis([cmin,cmax])
% %xlim([lonmin,lonmax]); ylim([latmin,latmax]);
% title(ptitle)
% text_line(2,[0.65,0.5,0.4])

if ifsave
    filename = ['fsle_',wstr,num2str(round(dsel*min_d/1000)),'km_',flstr(1:2),'_',timestr,'_',...
        num2str(grdnum),num2str(level),seas_str];
    export_fig(gcf,[filepath, filename,'.png'],'-m2','-r72','-q95','-transparent')
end

if ifw
    numnum = dsel
else
    numnum = round(dsel*min_d/1000);
end
end

end

function plot_settings(lon,lat,field,ptitle,iffig,ifcol,iftitle,ifunique,varargin)    
if iffig; figure; end
psize = 20;
scatter(lon,lat,psize,field,'filled')
%pcolorjw(lon,lat,sq(field)); shading flat
axis equal
axis tight
hold on
world_coast
if ifcol; colorbar('EastOutside'); end
% fm = nanmean(field(:)); fs = nanstd(field(:));
% cmin = fm-2*fs; cmax = fm+2*fs;
% caxis([cmin,cmax])
%xlim([lonmin,lonmax]); ylim([latmin,latmax]);
if iftitle; if ifunique; title(ptitle); else title(varargin{1}); end; end
text_line(2,[0.65,0.5,0.4])
end

function subplotting()
grdnum = 1; le = 'fsle'; le_num = 60; % in kilometres or days 
figure;
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    lvec = {'15m' '30m' '60m' '150m'};
    subplot1(5,2);
    r = 1;
    cvec = [0,0.15];
    subplot1(1)
    numnum = FTLE_FSLE(grdnum,1,r,1,0,le,le_num,0);
    if strcmp(le,'fsle'); lestr = [le,'_',num2str(numnum),'km'];
    elseif strcmp(le,'ftle'); lestr = [le,'_',num2str(numnum),'days'];
    end
    h1 = colorbar('EastOutside');
    %a1 = get(h1,'Position'); set(h1,'Position',[0.1,0.52,0.84,0.048])
    %set(h1,'Position',[a(1),0.5,a(3)+0.7,a(4)])
    caxis(cvec)
    title(timestrvec{r})
    ylabel('2d 15m')
    for i = 1:4
        subplot1(i*2+1)
        FTLE_FSLE(grdnum,2,r,i,0,le,le_num,0);
        caxis(cvec)
        ylabel(['3d ',lvec{i}])
        if i == 4; h = colorbar('Location','South');
        set(h,'Position',[0.1,0.04,0.84,0.02])
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.04,a(2),a(3),a(4)])
        end
    end
    r = 2;
    cvec = [0,0.15];
    subplot1(2)
    FTLE_FSLE(grdnum,1,r,1,0,le,le_num,0);
    %h2 = colorbar('SouthOutside');
    %a2 = get(h2,'Position'); set(h2,'Position',[0.1,0.06,0.84,0.048])
    %set(h2,'Position',[a(1),0,a(3)+0.7,a(4)])
    caxis(cvec)
    title(timestrvec{r})
    for i = 1:4
        subplot1(i*2+2)
        FTLE_FSLE(grdnum,2,r,i,0,le,le_num,0);
        caxis(cvec)
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.06,a(2),a(3),a(4)])
        %end
    end
export_fig(gcf,[lestr,'_',cpstr(grdnum,1),'.png'],'-m2','-r72','-q95','-transparent')
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    subplot1(2,5);
    r = 1;
    cvec = [0,0.3];
    subplot1(1)
    numnum = FTLE_FSLE(grdnum,1,r,1,0,le,le_num);
    if strcmp(le,'fsle'); lestr = [le,'_',num2str(le_num),'km'];
    elseif strcmp(le,'ftle'); lestr = [le,'_',num2str(le_num),'days'];
    end
    h1 = colorbar('SouthOutside');
    a1 = get(h1,'Position'); set(h1,'Position',[0.1,0.52,0.84,0.048])
    %set(h1,'Position',[a(1),0.5,a(3)+0.7,a(4)])
    caxis(cvec)
    ylabel(timestrvec{r})
    for i = 1:4
        subplot1(i+1)
        FTLE_FSLE(grdnum,2,r,i,0,le,le_num);
        caxis(cvec)
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.04,a(2),a(3),a(4)])
        %end
    end
    r = 6;
    cvec = [0,0.5];
    subplot1(6)
    FTLE_FSLE(grdnum,1,r,1,0,le,le_num);
    h2 = colorbar('SouthOutside');
    a2 = get(h2,'Position'); set(h2,'Position',[0.1,0.06,0.84,0.048])
    %set(h2,'Position',[a(1),0,a(3)+0.7,a(4)])
    caxis(cvec)
    ylabel(timestrvec{r})
    title('')
    for i = 1:4
        subplot1(i+6)
        FTLE_FSLE(grdnum,2,r,i,0,le,le_num);
        caxis(cvec)
        title('')
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.06,a(2),a(3),a(4)])
        %end
    end
end
export_fig(gcf,[lestr,'_',cpstr(grdnum,1),'.png'],'-m2','-r72','-q95','-transparent')
end