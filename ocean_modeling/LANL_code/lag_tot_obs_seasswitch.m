function lag_tot_obs_seasswitch(grdnum,f,level,seas_in)
%% Calculate statistics over m x n bins
%   Input: grd number
%          f: 2d or 3d
%          level: deployment level
%          seas_in = 0: annual
%          seas_in = eg. 1:4 :months
%

if f == 1 && level > 1
    return;
end

filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/analysis/';

if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    grd = rnt_gridload('soatl1');
    deg = 1; % size of bins
    npart = 6482;
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    grd = rnt_gridload('soatl3');
    deg = 10; 
    npart = 4980;
end

lonmin = min(grd.lonr(:)); lonmax = max(grd.lonr(:));
latmin = min(grd.latr(:)); latmax = max(grd.latr(:));

extent = [latmin,latmax,lonmin,lonmax];

% size of binned field
m = ceil((extent(2)-extent(1))*deg);
n = ceil((extent(4)-extent(3))*deg);

% bin bounds
latex = linspace(extent(1),extent(2),m)';
lonex = linspace(extent(3),extent(4),n)';

% initialize observation matrix
nobs = zeros(m-1,n-1);
nobs_p = zeros(m-1,n-1,npart);
npobs = zeros(m-1,n-1);
nobs1 = zeros(m-1,n-1);

% constants
flstrvec = {'2d_z15m' '3d'};
zstrvec = {'z0' 'z'};

flstr = flstrvec{f};
zstr = zstrvec{f};

% number of timesteps in data
tlength = 0;

for t = 1:length(timestrvec)
    disp(['Release ',num2str(t)])
    timestr = timestrvec{t};
    
    nobs_p = zeros(m-1,n-1,npart);
    
    for mo = 1:length(seas_in) % loop over months
        try lag_field = lag_load(grdnum,f,t,level,seas_in(mo),0,0,1,0);
            % this function loads field in convenient structure
        catch; continue; end
        
        lon = lag_field.lon;
        lat = lag_field.lat;
        
        tic; % ~60s
        for p = 1:size(lat,3) % loop over particles
            for t1 = 1:size(lat,1) % loop over time
                if isnan(lon(t1,1,p)); continue; end
                i = find(lat(t1,1,p) < latex,1);
                j = find(lon(t1,1,p) < lonex,1);
                nobs(i-1,j-1) = nobs(i-1,j-1) + 1;
                nobs_p(i-1,j-1,p) = nobs_p(i-1,j-1,p) + 1;
                if lag_field.tem(t1,1,p) == 0; continue; end
                nobs1(i-1,j-1) = nobs1(i-1,j-1) + 1; % real nobs
            end
        end
        toc;
        
        tlength = tlength + size(lon,1);
        clear lag_field
    end
    
    npobs = npobs + sum(nobs_p > 0,3);
    clear nobs_p
end

% create mesh for plotting
[lnx,ltx] = meshgrid(lonex,latex);
yy = (ltx(1:end-1,1:end-1) + ltx(2:end,2:end))/2;
xx = (lnx(1:end-1,1:end-1) + lnx(2:end,2:end))/2;

mask = ones(size(nobs));
mask(nobs == 0) = NaN;

if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
end

filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
save([filepath,filename,'.mat'],'nobs','npobs','nobs1','tlength','xx','yy','mask')
end

function plotting()

% load file and plot
lvec = {'15m' '30m' '60m' '150m'};
flstrvec = {'2d_z15m' '3d'};
dt = 0.25; 
Lt = zeros(3,2,4); Lt(:,1,1) = [7,0,3]; Lt(1,2,:) = [7,7,7,12]; Lt(3,2,:) = [3,3,3.5,8];
%Lt = zeros(3,2,4); Lt(:,1,1) = [5,0,3]; Lt(1,2,:) = [7,7,9,15]; Lt(3,2,:) = [3,3,3,7];
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/analysis/';
mstr = monthstr(1:12);
for mon = 1:12;
    seas_str = ['_',mstr(mon,:)];
for grdnum = [1,3]
    for f = 1:2
        for level = 1:4
            flstr = flstrvec{f};
            
            filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            try load([filename,'.mat'])
            catch; continue; end
            
%             if level > 1; e = dt/(2*Tl{2});
%             else e = dt/(2*Tl{1}); end
            e = dt/(2*Lt(grdnum,f,level));
            figure;
            pcolorjw(xx,yy,nobs1.*mask*e); shading flat
            
            if grdnum == 1; cvec = [0,450];
                if level == 1; cvec = [0,450];
                elseif level == 2; cvec = [0,450];
                elseif level == 3; cvec = [0,360];
                elseif level == 4; cvec = [0,270];
                end
            elseif grdnum == 3; cvec = [0,270];
                if level == 1; cvec = [0,270];
                elseif level == 2; cvec = [0,270];
                elseif level == 3; cvec = [0,210];
                elseif level == 4; cvec = [0,120];
                end
            end
            
            yell_green_blue_9levels
            cb = colorbar('EastOutside'); colormap(rgb); caxis(cvec)
            ci = linspace(cvec(1),cvec(2),size(rgb,1)+1);
            set(cb,'ytick',round(ci));
            axis equal
            axis tight
            hold on; world_coast; 
            ptitle = ['Independent ',flstr(1:2),' ',lvec{level},' ',...
                cpstr(grdnum,1),' ',num2str(nansum(nobs1(:)*e),2),strrep(seas_str,'_',' ')];
            title(ptitle)
            text_line(2,[0.65 0.5 0.4])
            set(gca,'color',[0.5 0.5 0.5])
            
            set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
            filename = ['nind_',flstr,'_',num2str(grdnum),num2str(level),seas_str];            
            export_fig(gcf,[filepath,filename,'.png'],'-m2','-r72','-q95','-transparent')
            
            % Number of observations per bin
%             figure;
%             pcolor(xx,yy,nobs.*mask); shading flat
%             
%             if grdnum == 1; cvec = [0,80000];
%             elseif grdnum == 3; cvec = [0,10000]; end
%             
%             colorbar; caxis(cvec)
%             axis equal
%             axis tight
%             ptitle = ['observations ',flstr(1:2),' ',lvec{level},' ',num2str(nansum(nobs(:)),2),seas_str];
%             title(ptitle)
%             set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
%             filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
%             export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
%            
%             
%             % Number of particles per bin
%             figure;
%             pcolor(xx,yy,npobs.*mask); shading flat
%             
%             if grdnum == 1; cvec = [0,800];
%             elseif grdnum == 3; cvec = [0,2000]; end
%             
%             colorbar; caxis(cvec)
%             axis equal
%             axis tight
%             ptitle = ['particles ',flstr(1:2),' ',lvec{level},' ',num2str(nansum(npobs(:)),2),seas_str];
%             title(ptitle)
%             set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
%             filename = ['npobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
%             export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
%              
        end
    end
end
end
end