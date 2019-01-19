%% Plotting trajectories horizontally

% loading three grids; trajectories only simulated on grd1(9km) and grd3 (1km)
grdnum = 3;

% Add option for new_HR data
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    cvec = [-150,-15;-165,-30;-180,0;-280,-40];
    grd = rnt_gridload('soatl1');
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    cvec = [-60,-15;-75,-30;-90,-30;-180,-120];
    grd = rnt_gridload('soatl3');
end

flstrvec = {'2d_z15m' '3d'};
lvec = {'15m' '30m' '60m' '150m'};
skip = 4;

% loading one floats file
filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/';

for f = 2
    flstr = flstrvec{f};
    
    if f == 1; ilevel = 1; ifcolor = 0;
    elseif f == 2; ilevel = [1,2,3,4]; ifcolor = 1;
    end
    
    for t = 1:length(timestrvec)
        timestr = timestrvec{t};
        for level = ilevel
                        
            % dim(time,level,float)
            % time-interval = 6hr
            
%             if ifcolor; z = nc{zstr}(1:end,level,1:end);
%                 zmin = nanmean(z(end,:,:),3)-std(z(end,:,:),[],3);
%             end
            
            lag_field = lag_load(grdnum,f,t,level,0);
            lon = lag_field.lon; lat = lag_field.lat; z = lag_field.z;
            lonmin = lag_field.extent(3); lonmax = lag_field.extent(4);
            latmin = lag_field.extent(1); latmax = lag_field.extent(2);
            
            % scatter plot the particles in a movie
            figure; clf
            for i = 1:skip:size(lon,1)
                
                if sum(~isnan(lon(i,1,:))) == 0; continue; end
                
                if ifcolor; colvec = z(i,1,:);
                else colvec = 'k';
                end
                
                scatter(lon(i,1,:),lat(i,1,:),5,colvec)
                hold on
                world_coast
                
                if ifcolor
                    %yell_green_blue_9levels
                    %mycolors=[r g b];
                    colormap(jet(10));
                    cax = cvec(level,:);
                    caxis(cax)
                    clevels = 10;%length(r);
                    ci = cax(1):(cax(2)-cax(1))/clevels:cax(2);
                    cb = colorbar('EastOutside');
                    set(cb,'ytick',ci);
                end
                
                hold on
                world_coast
                axis equal
                axis tight
                xlim([lonmin,lonmax]); ylim([latmin,latmax]);
                title([timestr,' ',cpstr(grdnum,1),' ',lvec{level},' ',num2str((i-1)/4),' days']);
                text_line(2,[0.65,0.5,0.4])
%                 set(gca,'PlotBoxAspectRatio',[1,1,abs(lonmax-lonmin)/abs(latmax-latmin)])
                frame(i) = getframe(gcf);
                clf
            end
            
            delay = 0.1;
            gifpath = '/atlas2/kjoshi36/LANL/lagrangian_data/gifs/';
            gifname = ([gifpath,flstr,'_',timestr,'_',num2str(grdnum),num2str(level)]);
            gif(gifname,frame,delay,1,4)
            
            close all; clear frame
            
        end
    end
end