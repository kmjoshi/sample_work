function lag_struct = lag_load2(grdnum,f,t,level,seas_in,varargin)
%% Load lagrangian trajectory data in a structure
%   INPUT
%       grdnum   = 1(LR) or 3(HR)
%       f        = 1(2d) or 2(3d)
%       t        = Release no.
%       level    = deployment level (1:4)
%       seas_in  = 0(annual) or month
%       varargin = save variable: (0 or 1) 
%                   (u,v), (w,wmean,wseas), (tem,sal), (umean,useas,vmean,vseas)
%
%   OUTPUT
%       lag_struct.grd = grd;
%       lag_struct.z = z;
%       lag_struct.lon = lon;
%       lag_struct.lat = lat;
%       lag_struct.extent = [latmin,latmax,lonmin,lonmax];
%       lag_struct.datenum = timevec;
%       lag_struct.filename = filename;
%    Optional:
%       lag_struct.u
%       lag_struct.v
%       lag_struct.w
%       lag_struct.wmean
%       lag_struct.wseas
%       lag_struct.tem
%       lag_struct.sal
%       lag_struct.umean
%       lag_struct.vmean
%       lag_struct.useas
%       lag_struct.vseas
%

if f == 1 && level > 1
    return;
end

HR_version = 2;

%% SETUP
clean = 1; % switch to save extra variable of removed particles onto nc file

% Constants
if grdnum == 1;
    timestrvec = {'1999M08D01' '1999M11D01' '2000M02D01' '2000M05D01'};
    grd = rnt_gridload('soatl1');
elseif grdnum == 3;
    if HR_version == 1
        timestrvec = {'1999M08D01' '1999M09D01' '1999M10D01' '1999M11D01' '1999M12D01' ...
            '2000M01D01' '2000M02D01' '2000M03D01' '2000M04D01' '2000M05D01' '2000M06D01' ...
            '2000M07D01'};
    elseif HR_version == 2
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
    end
    grd = rnt_gridload('soatl3');
end

flstrvec = {'2d_z15m' '3d'};
zstrvec = {'z0' 'z'};

% loading one floats file
if grdnum == 3 && HR_version == 1
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/old_HR/';
else
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/';
end

flstr = flstrvec{f};
zstr = zstrvec{f};

timestr = timestrvec{t};


filename = [filepath,'floats',flstr,'_releaseY',timestr,'_out.nc.',num2str(grdnum)];
nc = netcdf(filename);

% dim(time,level,float)
% time-interval = 6hr

%% seas switch select times
if seas_in == 0
    disp('annual')
    time_in = 1:length(nc{'time'});
nc_time = nc{'time'}(:);
refdate = '01-01-1990';
timevec = nc_time + datenum(refdate);
else
nc_time = nc{'time'}(:);
refdate = '01-01-1990';
timevec = nc_time + datenum(refdate);
[~,month_in,~,~,~,~] = datevec(nc_time + datenum(refdate));

time_in = find(month_in >= seas_in(1) & month_in <= seas_in(end));

if isempty(time_in); disp('Try another release'); return; end

if find(diff(time_in) >1) %netcdf cannot load incontiguous data, split timeseries
    ict = find(diff(time_in) >1);
    time_in1 = time_in(1:ict); 
    time_in2 = time_in(ict+1:end);
end
end
%%

% Loop for adding cleaned coordinates
if clean
lon = nc{'lon'}(time_in,level,1:end)-360;
lat = nc{'lat'}(time_in,level,1:end);
disp('removing particles')
close(nc)
nc = netcdf(filename,'w');
nc{'klon'} = ncfloat('time','ilevel','ifloat');
nc{'klon'}.long_name = ncchar('Particles still in domain');
nc{'klon'}.units = ncchar('degrees_east');
endef(nc)
tic; klon = lon; % ~2s
for i = 1:size(lon,1)-1
    a = find(lon(i,1,:) == lon(i+1,1,:) & lat(i,1,:) == lat(i+1,1,:));
    klon(i+1,1,a) = NaN;
end;
nc{'klon'}(:,level,:) = klon;
close(nc)
nc = netcdf(filename);
end

if find(diff(time_in) >1)
    disp('split time')
    z1 = nc{zstr}(time_in1,level,1:end);
lon1 = nc{'klon'}(time_in1,level,1:end); % stick with Manu convention
lat1 = nc{'lat'}(time_in1,level,1:end);
    z2 = nc{zstr}(time_in2,level,1:end);
lon2 = nc{'klon'}(time_in2,level,1:end); % stick with Manu convention
lat2 = nc{'lat'}(time_in2,level,1:end);

z = cat(1,z1,z2); lat = cat(1,lat1,lat2); lon = cat(1,lon1,lon2);
else
    z = nc{zstr}(time_in,level,1:end);
    lon = nc{'klon'}(time_in,level,1:end); % stick with Manu convention
    lat = nc{'lat'}(time_in,level,1:end);
end

if nargin > 5
%     for v = 1:length(varargin)
%         eval([varargin{v},' = zeros(size(z));'])
%         eval([varargin{v},' = nc{',varargin{v},'}(time_in,level,1:end);'])
%         eval(['lag_struct.',varargin{v},' = ',varargin{v},';'])
%     end
    if varargin{1} == 1
    lag_struct.u = nc{'uvl'}(time_in,level,1:end);
    lag_struct.v = nc{'vvl'}(time_in,level,1:end);
    end
    if varargin{2} == 1
    lag_struct.w = nc{'wvl'}(time_in,level,1:end);
    try lag_struct.wmean = nc{'wmean'}(time_in,level,1:end);
        lag_struct.wseas = nc{'wseas'}(time_in,level,1:end);
    catch; disp('No Wmean'); end
    end
    if varargin{3} == 1
    lag_struct.tem = nc{'tem'}(time_in,level,1:end);
    lag_struct.sal = nc{'sal'}(time_in,level,1:end);
    end
    if varargin{4} == 1
    try 
        lag_struct.umean = nc{'umean'}(time_in,level,1:end);
        lag_struct.vmean = nc{'vmean'}(time_in,level,1:end);
        lag_struct.useas = nc{'useas'}(time_in,level,1:end);
        lag_struct.vseas = nc{'vseas'}(time_in,level,1:end);
    catch; disp('NO MEANS'); 
    end
    end        
end

close(nc)
 
lonmin = min(grd.lonr(:)); lonmax = max(grd.lonr(:));
latmin = min(grd.latr(:)); latmax = max(grd.latr(:));

lag_struct.grd = grd;
lag_struct.z = z;
lag_struct.lon = lon;
lag_struct.lat = lat;
lag_struct.extent = [latmin,latmax,lonmin,lonmax];
lag_struct.datenum = timevec;
lag_struct.filename = filename;

%eval([varargin{v},' = nc_varget(',filename,',',varargin{v},');'])

end
