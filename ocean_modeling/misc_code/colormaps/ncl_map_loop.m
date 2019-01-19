function ncl_map_loop()
%%  ncl_map_loop()
%   Loops through all ncl database colormaps
%

map_list = dir('/nas/kjoshi36/main-data/colormaps/*.mat');

l = length(map_list);

for i = 1:l
    map = map_list(i).name(1:end-4);
    ncl_map(map)
    %title(strrep(map,'_',' '))
    disp(strrep(map,'_',' '))
    pause
end
end

