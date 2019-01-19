function plot_mean_streamslice(grdnum,depthin)

grd = rnt_gridload(['soatl',num2str(grdnum)]);
%depthin = -30;
nc = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_grid',num2str(grdnum),'.nc']);
nc1 = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_JJAS_grid',num2str(grdnum),'.nc']);
nc2 = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_NDJFM_grid',num2str(grdnum),'.nc']);

u = nc{'u'}(:); u1 = nc1{'u'}(:); u2 = nc2{'u'}(:);
v = nc{'v'}(:); v1 = nc1{'v'}(:); v2 = nc2{'v'}(:);

u = permute(u,[3,2,1]); u1 = permute(u1,[3,2,1]); u2 = permute(u2,[3,2,1]);
v = permute(v,[3,2,1]); v1 = permute(v1,[3,2,1]); v2 = permute(v2,[3,2,1]);
z_r = zlevs(grd.h,0,grd.thetas,grd.thetab,grd.hc,grd.N,0);
z_r = permute(z_r,[2,3,1]);
z_r_u = rnt_2grid(z_r,'r','u'); z_r_v = rnt_2grid(z_r,'r','v');

uz = rnt_2z(u,z_r_u,depthin); u1z = rnt_2z(u1,z_r_u,depthin); u2z = rnt_2z(u2,z_r_u,depthin);
vz = rnt_2z(v,z_r_v,depthin); v1z = rnt_2z(v1,z_r_v,depthin); v2z = rnt_2z(v2,z_r_v,depthin);

uzp = rnt_2grid(uz,'r','v'); u1zp = rnt_2grid(u1z,'r','v'); u2zp = rnt_2grid(u2z,'r','v');
vzp = rnt_2grid(vz,'r','u'); v1zp = rnt_2grid(v1z,'r','u'); v2zp = rnt_2grid(v2z,'r','u');

[lon,lat,mask] = gridcheck(grd,uzp);
ax(1)=min(lon(:)); ax(2)=max(lon(:)); ax(3)=min(lat(:)); ax(4)=max(lat(:));
% m_proj('mercator','lon',ax(1:2),'lat',ax(3:4));
% 
% m_grid;
% m_coast('patch',[0.65 0.5 0.4],'edgecolor',[0.65 0.5 0.4],'linewidth',1);
figure; 
if grdnum == 1; subplot1(3,1); else subplot1(1,3); end

subplot1(1)
sh = streamslice(lon',lat',uzp'.*mask',vzp'.*mask',1.5);
set(sh,'color','black','linewidth',1)
hold on; world_coast
axis equal; axis tight
xlim([ax(1),ax(2)]); ylim([ax(3),ax(4)]);
h = title('ANNUAL');
if grdnum == 1; set(h,'Position',[2.65,-14,208]); end
hold on; pcolor(lon,lat,sqrt(uzp.^2+vzp.^2).*mask); shading flat
rectangle('Position',[-34,-20,35,10],'Linewidth',3)

subplot1(2)
sh = streamslice(lon',lat',u1zp'.*mask',v1zp'.*mask',1.5);
set(sh,'color','black','linewidth',1)
hold on; world_coast
axis equal; axis tight
xlim([ax(1),ax(2)]); ylim([ax(3),ax(4)]);
h = title('JJAS');
if grdnum == 1; set(h,'Position',[2.65,-14,208]); end
hold on; pcolor(lon,lat,sqrt(u1zp.^2+v1zp.^2).*mask); shading flat

subplot1(3); 
sh = streamslice(lon',lat',u2zp'.*mask',v2zp'.*mask',1.5);
set(sh,'color','black','linewidth',1)
hold on; world_coast
axis equal; axis tight
xlim([ax(1),ax(2)]); ylim([ax(3),ax(4)]);
h = title('NDJFM');
if grdnum == 1; set(h,'Position',[2.65,-14,208]); end
hold on; pcolor(lon,lat,sqrt(u2zp.^2+v2zp.^2).*mask); shading flat
text_line(1)

if grdnum == 3
    b = colorbar('Location','SouthOutside');
    set(b,'Position',[0.1,0.2,0.84,0.03])
elseif grdnum == 1
    b = colorbar('Location','WestOutside');
    set(b,'Position',[0.1,0.1,0.03,0.84])
end


export_fig(gcf,['/atlas2/kjoshi36/LANL/eulerian_data/streamline',num2str(grdnum),...
    num2str(-depthin),'m.png'],'-m2','-r72','-q95','-transparent')
%[ncst,area,k] = mu_coast('default',{'patch',[.65 .5 .4],'edgecolor','k','linewidth',1},...
%    'tag','m_coast');

end


function plotting_quiver()
grdnum = 1; depthin = -15;

grd = rnt_gridload(['soatl',num2str(grdnum)]);
%depthin = -30;
nc = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_grid',num2str(grdnum),'.nc']);
%nc1 = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_JJAS_grid',num2str(grdnum),'.nc']);
%nc2 = netcdf(['/atlas2/kjoshi36/LANL/eulerian_data/mean_NDJFM_grid',num2str(grdnum),'.nc']);

u = nc{'u'}(:); %u1 = nc1{'u'}(:); u2 = nc2{'u'}(:);
v = nc{'v'}(:); %v1 = nc1{'v'}(:); v2 = nc2{'v'}(:);

u = permute(u,[3,2,1]); %u1 = permute(u1,[3,2,1]); u2 = permute(u2,[3,2,1]);
v = permute(v,[3,2,1]); %v1 = permute(v1,[3,2,1]); v2 = permute(v2,[3,2,1]);
z_r = zlevs(grd.h,0,grd.thetas,grd.thetab,grd.hc,grd.N,0);
z_r = permute(z_r,[2,3,1]);
z_r_u = rnt_2grid(z_r,'r','u'); z_r_v = rnt_2grid(z_r,'r','v');

uz = rnt_2z(u,z_r_u,depthin); %u1z = rnt_2z(u1,z_r_u,depthin); u2z = rnt_2z(u2,z_r_u,depthin);
vz = rnt_2z(v,z_r_v,depthin); %v1z = rnt_2z(v1,z_r_v,depthin); v2z = rnt_2z(v2,z_r_v,depthin);

uzp = rnt_2grid(uz,'r','v'); %u1zp = rnt_2grid(u1z,'r','v'); u2zp = rnt_2grid(u2z,'r','v');
vzp = rnt_2grid(vz,'r','u'); %v1zp = rnt_2grid(v1z,'r','u'); v2zp = rnt_2grid(v2z,'r','u');

[lon,lat,mask] = gridcheck(grd,uzp);
ax(1)=min(lon(:)); ax(2)=max(lon(:)); ax(3)=min(lat(:)); ax(4)=max(lat(:));
% m_proj('mercator','lon',ax(1:2),'lat',ax(3:4));
% 
% m_grid;
iskip = 5; scale = 1;

  quiver(lon(1:iskip:end,1:iskip:end),lat(1:iskip:end,1:iskip:end),...
      scale*uzp(1:iskip:end,1:iskip:end).*mask(1:iskip:end,1:iskip:end),...
      scale*vzp(1:iskip:end,1:iskip:end).*mask(1:iskip:end,1:iskip:end),...
      0,'color',[0 0 0],'linewidth',1)

  %ax = axis;
  axis equal;
  %if exist('subregion','var') & ~isempty(subregion),
  %  axis(subregion);
  %else
    %axis(ax);
    axis tight;
  %end

  load coast.mat
  %plot(coast.lon,coast.lat,'k','linewidth',1.2);
  fillseg(ncst,[0.65 0.5 0.4],[0.65 0.5 0.4]); % land light brown
end