function make_ncl_map(filename,mapname)
%%  make_ncl_map(filename,mapname)
%   makes mat-files from ncl-downloaded rgb files
%   filename - .rgb filename (without extension)
%   mapname - desired name of new colormap (mapname.mat)
%

rgb = dlmread(filename,'',2,0);
if max(rgb) > 1
rgb = rgb/256;
end
save([mapname,'.mat'],'rgb')

end