function ncl_map(mapname,varargin)
%%  ncl_map(mapname)
%   Changes current colormap to mapname
%   mapname = name of matfile
%   or loads matlab colormap of same name
%

%try
load(['/nas/kjoshi36/main-data/colormaps/',mapname,'.mat'])
colormap(rgb)
%catch
%   colormap(mapname)
%end

end