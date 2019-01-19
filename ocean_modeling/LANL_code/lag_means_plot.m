function lag_means_plot(g,fl,l,seas_in,ifsave)
%%  Load ouput from LAGRANGIAN_MEANS.M and plot each variable
%   lag_means_plot(g,fl,l,seas_in,ifsave)
%
%   INPUT:
%       g = grdnum: 1(LR) 3(HR)
%       fl = 1(2D) 2(3D)
%       l = level: 1(15m) 2(30m) 3(60m) 4(150m)
%       seas_in = vector of months [6:9](JJAS) [11,12,1,2,3](NDJFM)
%       ifsave = switch to save plots or not
%
%   optional: change cvec = color limits for each plot

global mask grdnum xx yy isave

if fl == 1 & l > 1 ; return; end;

    % load file and plot
lvec = {'15m' '30m' '60m' '150m'};
flstrvec = {'2d_z15m' '3d'};
dt = 0.25; Tl = {3 10}; % decorrelation timescale for each resolution
% plotting of no. of independent particles is better done with
% lag_tot_obs_seasswitch.m

%% plot_'var' are switches to plot any variable desired with fixed plot_settings
plot_nobs = 0;
plot_nobs1 = 1;
plot_npobs = 0;
isave = ifsave;

if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
end

for grdnum = g
    for f = fl
        if f == 1
            plot_u = 0;
            plot_v = 0;
            plot_quiver = 0;
            plot_uv_corr = 0;
            plot_varu = 0;
            plot_varv = 0;
            plot_eke = 0;
            plot_tem = 0;
            plot_sal = 0;
            
            plot_z = 0; % DO NOT CHANGE
        else
            plot_z = 1; % DO NOT CHANGE
            
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
        for level = l
            
            flstr = flstrvec{f};
            
            filename = ['lag_means_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            try load([filename,'.mat'])
            catch; continue; end
            
            %nfname = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
            %try load([filename,'.mat'])
            %catch; continue; end
            
            if level > 1; e = dt/(2*Tl{2});
            else e = dt/(2*Tl{1}); end            
           
            nmask = logical(nobs*e > 20);
            nmask = double(nmask);
            nmask(nmask == 0) = NaN;
            
            if plot_nobs
                variable = nobs*e;
                cvec = [0,3000;0,1000;0,1000;0,200];
                ptitle = ['nind ',flstr(1:2),' ',lvec{level},' ',num2str(nansum(variable(:)),2),seas_str(2:end)];
                filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable,cvec,ptitle,filename)
            end
            
            if plot_nobs1
                variable = nobs1*e;
                cvec = [0,3000;0,100];
                ptitle = ['nind ',flstr(1:2),' ',lvec{level},' ',num2str(nansum(variable(:)),2),seas_str(2:end)];
                filename = ['nobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable,cvec,ptitle,filename)
            end
            
            if plot_npobs
                variable = npobs;
                cvec = [0,1500;0,200;0,200;0,100];
                ptitle = ['npobs ',flstr(1:2),' ',lvec{level},' ',num2str(nansum(variable(:)),2),seas_str(2:end)];
                filename = ['npobs_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable,cvec,ptitle,filename)
            end
            
            if plot_u
                variable = u;
                cvec = [-0.1,0.1;-0.1,0.1];
                ptitle = ['u ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['u_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_v
                variable = v;
                cvec = [-0.1,0.1;-0.1,0.1];
                ptitle = ['v ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['v_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_uv_corr
                variable = uv_corr;
                cvec = [-0.004,0.004;-0.008,0.008];
                ptitle = ['uv corr ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['uv_corr_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_varu
                variable = varu;
                cvec = [0,0.03;0,0.03];
                ptitle = ['varu ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['varu_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_varv
                variable = varv;
                cvec = [0,0.03;0,0.03];
                ptitle = ['varv ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['varv_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_eke
                variable = (varu + varv)/2;
                cvec = [0,0.03;0,0.03];
                ptitle = ['eke ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['eke_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_tem
                variable = tem;
                cvec = [19,28;26,27.8];
                ptitle = ['tem ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['tem_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_sal
                variable = sal;
                cvec = [34.5,37.5;37,37.36];
                ptitle = ['sal ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                filename = ['sal_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                plot_settings(variable.*nmask,cvec,ptitle,filename)
            end
            
            if plot_quiver
                figure;
                if grdnum == 1; scale = 10;
                else scale = 2; end
                quiver(xx,yy,u.*mask.*nmask*scale,v.*mask.*nmask*scale,0);
                ptitle = [flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                axis equal
                axis tight
                title(ptitle)
                set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
                if ifsave
                    filename = ['quiver_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
                end
            end
            
            if plot_z
                variable = z;
                ptitle = ['z ',flstr(1:2),' ',lvec{level},' ',cpstr(grdnum,1),' ',seas_str(2:end)];
                figure;
                pcolorjw(xx,yy,z.*mask.*nmask); shading flat
                
                if grdnum == 1;
                    if level == 1; cvec = [-100,0];
                    elseif level == 2; cvec = [-100,-10];
                    elseif level == 3; cvec = [-100,-40];
                    elseif level == 4; cvec = [-250,-100];
                    end
                end
                
                colorbar;
                if grdnum == 3; if level == 1; cvec = [-42,-15];
                    elseif level == 2; cvec = [-41,-23];
                    elseif level == 3; cvec = [-66,-49];
                    elseif level == 4; cvec = [-167,-140];
                    end 
                end
%                     caxis('auto')
%                 else caxis(cvec); end
                
                yell_green_blue_9levels
                cb = colorbar('EastOutside'); colormap(rgb); caxis(cvec)
                ci = roundsd(linspace(cvec(1),cvec(2),10),3);
                set(cb,'ytick',ci);
                axis equal
                axis tight
                hold on; world_coast;
                title(ptitle)
                text_line(2,'k')
                set(gca,'color',[0.5 0.5 0.5])
                
                set(findall(gcf,'type','text'),'FontName','Helvetica','fontWeight','bold')
                if ifsave
                    filename = ['z_',flstr,'_',num2str(grdnum),num2str(level),seas_str];
                    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
                end
            end
        end
    end
end
end

function plot_settings(variable,cvec,ptitle,filename)

global mask grdnum xx yy isave

figure;
pcolorjw(xx,yy,variable.*mask); shading flat

if grdnum == 1; cvec1 = cvec(1,:);
elseif grdnum == 3; cvec1 = cvec(2,:);
end

blue_darkred_12levels
cb = colorbar('EastOutside'); colormap(rgb); caxis(cvec1)
ci = linspace(cvec1(1),cvec1(2),size(rgb,1)+1);
set(cb,'ytick',ci);
axis equal
axis tight
hold on; world_coast;
title(ptitle)
text_line(2,'k')
set(gca,'color',[0.5 0.5 0.5])

if isave
    export_fig(gcf,[filename,'.png'],'-m2','-r72','-q95','-transparent')
end

end