function plot_trajs_var(vstr,cvec,param)
%% Plotting trajectories horizontally

% loading three grids; trajectories only simulated on grd1(9km) and grd3 (1km)
grdnum = 3;
f = 2;
t = 2;
level = 1;

grdnum = param(1);f = param(2);t = param(3);level = param(4);

if grdnum == 1;
    timestrvec = {'1999M08D01' '1999M11D01' '2000M02D01' '2000M05D01'};
    grd = rnt_gridload('soatl1');
elseif grdnum == 3;
    % OLD HR
    %timestrvec = {'1999M08D01' '1999M09D01' '1999M10D01' '1999M11D01' '1999M12D01' '2000M01D01'...
    %    '2000M02D01' '2000M03D01' '2000M04D01' '2000M05D01' '2000M06D01' '2000M07D01'};
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
    grd = rnt_gridload('soatl3');
end

flstrvec = {'2d_z15m' '3d'};
%zstrvec = {'z0' 'z'};

skip = 1;
ifcolor = 1;

% loading one floats file
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/';%old_HR/';

%for f = 1:2
flstr = flstrvec{f};
%zstr = zstrvec{f};

if f == 1; ilevel = 1; %ifcolor = 0;
elseif f == 2; ilevel = [1,2,3,4]; %ifcolor = 1;
end

%    for t = 1:length(timestrvec)
timestr = timestrvec{t};
%        for level = ilevel

nc = netcdf([filepath,'floats',flstr,'_releaseY',timestr,'_out.nc.',num2str(grdnum)]);

% dim(time,level,float)
% time-interval = 6hr

if ifcolor; z = nc{vstr}(1:end,level,1:end);
    %zmin = nanmean(z(end,:,:),3)-std(z(end,:,:),[],3);
end

lon = nc{'klon'}(1:end,level,1:end);
lat = nc{'lat'}(1:end,level,1:end);

lonmin = min(grd.lonr(:)); lonmax = max(grd.lonr(:));
latmin = min(grd.latr(:)); latmax = max(grd.latr(:));

% scatter plot the particles in a movie
figure; clf
for i = 1:skip:size(lon,1)
    
    if sum(~isnan(lon(i,1,:))) == 0
        continue; end
    
    if ifcolor; colvec = z(i,1,:);
    else colvec = 'k';
    end
    
    scatter(lon(i,1,:),lat(i,1,:),3,colvec,'Filled')
    hold on
    %scatter(lon(i,1,3070),lat(i,1,3070),40,'y','Filled')
    world_coast
    
    if ifcolor
        blue_darkred_12levels
        cb = colorbar('EastOutside'); colormap(rgb); caxis(cvec)
        ci = linspace(cvec(1),cvec(2),size(rgb,1)+1);
        set(cb,'ytick',ci);
%         colorbar
%         caxis(cvec)
    end
    %load(['../analysis/old_obs/nobs_',flstr,'_',num2str(grdnum),num2str(level),...
    load(['../analysis/nobs_',flstr,'_',num2str(grdnum),num2str(level),...
        '_APR.mat'],'xx','yy')
    xlim([mean(xx(1,1:2)),mean(xx(1,end-1:end))])
    ylim([mean(yy(1:2,1)),mean(yy(end-1:end,1))])
    set(gca,'Xtick',roundsd(xx(1,:),3),'YTick',roundsd(yy(:,1),3))
    grid on
    %xlim([lonmin,lonmax]); ylim([latmin,latmax]);
    axis equal
    axis tight
    xlim([lonmin,lonmax]); ylim([latmin,latmax]);
    %xlim([-32.1,-31.8]); ylim([-12.8,-12.5])
    title([num2str((i-1)/4),' days']);
    %set(gca,'PlotBoxAspectRatio',[1,1,abs(lonmax-lonmin)/abs(latmax-latmin)])
    frame(i) = getframe(gcf);
    %pause
    clf
end

delay = 0.1;
gifpath = '/atlas2/kjoshi36/LANL/lagrangian_data/gifs/other/';
gifname = ([gifpath,vstr,'_',flstr,'_',timestr,'_',num2str(grdnum),num2str(level)]);
gif(gifname,frame,delay,1,4)

%close all; clear frame

%        end
%    end
end