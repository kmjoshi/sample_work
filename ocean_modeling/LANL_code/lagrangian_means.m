function lagrangian_means(grdnum,f,level,seas_in)
%% Calculate statistics over m x n bins
% variables:
%   u,v,uv,u2,v2,correlation of uv, std(u), std(v) (only 2d)
%   nobserved particles -> nobserved per particle per bin
%   tem, salt (only 2d)
%   avg particle depth/time
%
%   OUTPUT: mat-file with all variable output
%
%   SEE LAG_MEANS_PLOT.M for plotting outputs of this function

if f == 1 && level > 1
    return;
end

if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
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

m = ceil((extent(2)-extent(1))*deg);
n = ceil((extent(4)-extent(3))*deg);

latex = linspace(extent(1),extent(2),m)';
lonex = linspace(extent(3),extent(4),n)';

nobs = zeros(m-1,n-1); % no. of observations + particles that are just beached
nobs1 = zeros(m-1,n-1); % no. of obsevations that are moving
nobs_p = zeros(m-1,n-1,npart); % no. of observations per particle in bin
u = zeros(m-1,n-1);
v = zeros(m-1,n-1);
u2 = zeros(m-1,n-1);
v2 = zeros(m-1,n-1);
uv = zeros(m-1,n-1);
tem = zeros(m-1,n-1);
sal = zeros(m-1,n-1);
z = zeros(m-1,n-1);

flstrvec = {'2d_z15m' '3d'};
zstrvec = {'z0' 'z'};

flstr = flstrvec{f};
zstr = zstrvec{f};

tlength = 0;

disp([grdnum,f,level])

for t = 1:length(timestrvec)
    disp(['Release ',num2str(t)])
    timestr = timestrvec{t};
    
    for m = 1:length(seas_in)
        try lag_field = lag_load_all(grdnum,f,t,level,seas_in(m));
        catch; continue; end
        
        lon = lag_field.lon;
        lat = lag_field.lat;
        
        tic; % ~60s
        for p = 1:size(lat,3)
            for t1 = 1:size(lat,1)
                if isnan(lon(t1,1,p)); continue; end
                i = find(lat(t1,1,p) < latex,1);
                j = find(lon(t1,1,p) < lonex,1);
                nobs(i-1,j-1) = nobs(i-1,j-1) + 1;
                nobs_p(i-1,j-1,p) = nobs_p(i-1,j-1,p) + 1;
                if f == 1
                    if lag_field.u(t1,1,p) == 0; continue; end
                    nobs1(i-1,j-1) = nobs1(i-1,j-1) + 1;
                    u(i-1,j-1) = u(i-1,j-1) + sq(lag_field.u(t1,1,p));
                    u2(i-1,j-1) = u2(i-1,j-1) + sq(lag_field.u(t1,1,p))^2;
                    v(i-1,j-1) = v(i-1,j-1) + sq(lag_field.v(t1,1,p));
                    v2(i-1,j-1) = v2(i-1,j-1) + sq(lag_field.v(t1,1,p))^2;
                    uv(i-1,j-1) = uv(i-1,j-1) + sq(lag_field.u(t1,1,p)*lag_field.v(t1,1,p));
                    tem(i-1,j-1) = tem(i-1,j-1) + sq(lag_field.tem(t1,1,p));
                    sal(i-1,j-1) = sal(i-1,j-1) + sq(lag_field.sal(t1,1,p));
                end
                if f == 2
                    z(i-1,j-1) = z(i-1,j-1) + sq(lag_field.z(t1,1,p));
                end
            end
        end
        toc;
        
        %eval(['nobs',num2str(t),' = nobs'])
        tlength = tlength + size(lon,1);
        clear lag_field
    end
    
end

npobs = sum(nobs_p > 0,3);
% except for lon,lat,z all other variables are set to zero at
% initialization
if f == 1
    ntot = sum(nobs(:));
    u = u./(nobs1);
    v = v./(nobs1);
    uv_corr = (uv - u.*v.*(nobs1))./(nobs1-1);
    varu = (u2 - u.^2.*(nobs1))./(nobs1-1);
    varv = (v2 - v.^2.*(nobs1))./(nobs1-1);
    tem = tem./(nobs1);
    sal = sal./(nobs1);
elseif f == 2
    z = z./nobs;
end

[lnx,ltx] = meshgrid(lonex,latex);
yy = (ltx(1:end-1,1:end-1) + ltx(2:end,2:end))/2;
xx = (lnx(1:end-1,1:end-1) + lnx(2:end,2:end))/2;

mask = ones(size(nobs));
mask(nobs == 0) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EDIT HERE
filename = ['lag_means_0.25deg',flstr,'_',num2str(grdnum),num2str(level),seas_str];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if f == 1;
    save([filepath,filename,'.mat'],'nobs','nobs1','nobs_p','npobs','tlength','xx','yy',...
        'mask','u','v','uv_corr','varu','varv','tem','sal')
elseif f == 2
    save([filepath,filename,'.mat'],'nobs','nobs_p','npobs','tlength','xx','yy',...
        'mask','z')
end

end

function plotting()

% when plotting plot on the midpoints of the meshgrid but set the axis to
% full extent

% load file and plot
lvec = {'15m' '30m' '60m' '150m'};
flstrvec = {'2d_z15m' '3d'};
dt = 0.25; Tl = {3 10};
seas_str = '';
ifsave = 0;
plot_nobs = 1;
plot_npobs = 1;
if f == 1
plot_u = 1;
plot_v = 1;
plot_quiver = 1;
plot_uv_corr = 1;
plot_varu = 1;
plot_varv = 1;
plot_eke = 1;
plot_tem = 1;
plot_sal = 1;

    plot_z = 0;
else
    plot_z = 1;

plot_u = 0;
plot_v = 0;
plot_quiver = 0;
plot_uv_corr = 0;
plot_varu = 0;
plot_varv = 0;
plot_eke = 0;
plot_tem = 0;
plot_sal = 0;
end

for grdnum = [1,3]
    for f = 1:2
        for level = 1:4
            
            grdnum = 1; f = 1; level = 1;
            
            flstr = flstrvec{f};
            
            filename = ['lag_means_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            try load([filename,'.mat'])
            catch; continue; end
            
            if level > 1; e = dt/(2*Tl{2});
            else e = dt/(2*Tl{1}); end
            
            % NIND
            if plot_nobs
                figure;
                pcolor(xx,yy,nobs.*mask*e); shading flat
                
                if grdnum == 1; cvec = [0,3000];
                    if level > 1; cvec = [0,700];
                    end
                elseif grdnum == 3; cvec = [0,500];
                    if level > 1; cvec = [0,150];
                    end
                end
                
                colorbar; caxis(cvec)
                axis equal
                axis tight
                ptitle = [flstr(1:2),' ',lvec{level},' ',num2str(nansum(nobs(:)*e),2),seas_str];
                title(ptitle)
                set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
                if ifsave
                    filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
                end
            end
            
            % Number of particles per bin
            if plot_npobs
                figure;
                pcolor(xx,yy,npobs.*mask); shading flat
                
                if grdnum == 1; cvec = [0,1000];
                    if level > 1; cvec = [0,200];
                    end
                elseif grdnum == 3; cvec = [0,200];
                    if level > 1; cvec = [0,50];
                    end
                end
                
                colorbar; caxis(cvec)
                axis equal
                axis tight
                ptitle = [flstr(1:2),' ',lvec{level},' ',num2str(nansum(nobs(:)*e),2),seas_str];
                title(ptitle)
                set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
                if ifsave
                    filename = ['npobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
                end
            end
            
            % Number of particles per bin
            if plot_npobs
                figure;
                pcolor(xx,yy,npobs.*mask); shading flat
                
                if grdnum == 1; cvec = [0,1000];
                    if level > 1; cvec = [0,200];
                    end
                elseif grdnum == 3; cvec = [0,200];
                    if level > 1; cvec = [0,50];
                    end
                end
                
                colorbar; caxis(cvec)
                axis equal
                axis tight
                ptitle = [flstr(1:2),' ',lvec{level},' ',num2str(nansum(nobs(:)*e),2),seas_str];
                title(ptitle)
                set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
                if ifsave
                    filename = ['npobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
                end
            end
            
            
            
            
            
            
        end
    end
end

end