function [area,grid_space,lon,lat] = mean_grid_spacing(grd)

a = grd.yr(:,2:end)-grd.yr(:,1:end-1);
b = grd.xr(2:end,:)-grd.xr(1:end-1,:);

lon = mean(a(:));
lat = mean(b(:));

area = lat*lon;
grid_space = (lat+lon)/2;
end

