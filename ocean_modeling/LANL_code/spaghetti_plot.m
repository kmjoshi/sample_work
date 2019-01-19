function spaghetti_plot(grdnum,f,level,r)

if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
elseif grdnum == 3;
        timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
            '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
end
lvec = {'15','30','60','150'};
figure;
clf
flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};
lag_field = lag_load(grdnum,f,r,level,0);
lon = sq(lag_field.lon); lat = sq(lag_field.lat);
pp = size(lon,2);
p = 1:20:pp;
t = 1:240;
plot(lon(t,p),lat(t,p))
hold on
axis equal
axis tight
world_coast
title(['Trajectories ',flstr(1:2),' ',cpstr(grdnum,0),' ',timestrvec{r},' ',lvec{level},'m'])
text_line(1)
export_fig(gcf,['/atlas2/kjoshi36/LANL/lagrangian_data/spag/spaghetti_plot_',...
    flstr(1:2),'_',timestrvec{r},'_',num2str(grdnum),num2str(level),'.png'],'-m2','-r72','-q95','-transparent')

end