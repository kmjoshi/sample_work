% EDIT below to specify details of initial condition

clear all;
%close all;

homedir = getenv('HOME');

eval(sprintf('addpath %s/romsagrif/romstools-2.1/Preprocessing_tools/',homedir))
eval(sprintf('addpath %s/romsagrif/romstools-2.1/Milenas_codes/new_scoord/',homedir))
eval(sprintf('addpath %s/matlab/toolboxes/roms_toolbox/',homedir))
eval(sprintf('addpath %s/roms/shared_codes/',homedir))

% NB: grid_level must be 0 for spinup:
%grid_level = 1; % 0=parent, 1=first nested child, etc
grid_level = 3;
if grid_level==0,
  endf = '';
else
  eval(sprintf('endf = ''.%d'';',grid_level));
end

grdname = 'soatl25km_r0.2';
maindir = [homedir '/submesoscale_NSFproject/roms_runs/'];
datadir = sprintf('%s/soatl_cyclbandzoom_ecmwf_forecast1224_6hourly/DATA',...
           maindir);
outdir = ['/Volumes/data3_external/ROMS_run/'...
          'soatl_cyclbandzoom_ecmwf_forecast1224_6hourly/DATA/'];

%TREF = dnref90;
TREF = datenum('01-01-1990');
timename = 'scrum_time';

% Redeployment time:
k = 1;
if grid_level==1,
  % Redeployment every 3 months:
  for im=[8,11],
    infile = sprintf('%s/roms_avg_Y1999M%d.nc%s',datadir,im,endf);
    time0(k) = nc_varget(infile,'scrum_time',[0],[1]); % seconds since TREF
    k = k+1;
  end
  for im=[2,5],
    infile = sprintf('%s/roms_avg_Y2000M%d.nc%s',datadir,im,endf);
    time0(k) = nc_varget(infile,'scrum_time',[0],[1]); % seconds since TREF
    k = k+1;
  end
  % Number of grid points near the boundary to skip for horizontal
  % distribution of particles:
  iskip = 10;
  % Release particles every dgrid points:
  dgrid = 3; % dgrid = 3 = 27 km
elseif grid_level==3,
%     files = rnt_getfilenames('/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data',...
%         '.3');
%     ctl = rnt_timectl(files,timename);
  % Redeployment every 5 days:
%   for im=8:12,
%     infile = sprintf('%s/roms_avg_Y1999M%d.nc%s',datadir,im,endf);
%     time0(k) = nc_varget(infile,'scrum_time',[0],[1]); % seconds since TREF
%     k = k+1;
%   end
%   for im=1:7,
%     infile = sprintf('%s/roms_avg_Y2000M%d.nc%s',datadir,im,endf);
%     time0(k) = nc_varget(infile,'scrum_time',[0],[1]); % seconds since TREF
%     k = k+1;
%   end

  % Number of grid points near the boundary to skip for horizontal
  % distribution of particles:
  iskip = 20;
  % Release particles every dgrid points:
  dgrid = 2;
else
  error(sprintf('Routine not setup for grid level=%d',grid_level))
end
%infile = sprintf('%s/roms_avg_Y2000M7.nc%s',datadir,endf);
%time = nc_varget(infile,'scrum_time'); % seconds since TREF
%time0 = time0/86400; % days since TREF
initial_time = 3.4991e3; % time in days sice 01-01-1990
end_time = 3.864e3;
deltat = 5; 
time0 = initial_time:deltat:end_time;
lifetime = time0(end) - time0;
% ifetime = time(end-3)/86400 - time0;

% Initial z-levels:
z0_2d = [-15]; % [m]
z0_3d = [-15 -30 -60 -150]; % [m]
%%%%%%%%%%%%%% END USER DEFINED VARIABLES %%%%%%%%%%%%%%%%

% Get grid info:
grd = rnt_gridload('soatl3');
%grdinfo = rnt_gridinfo([grdname endf]);
%grdfile = grdinfo.grdfile;
%lon = nc_varget(grdfile,'lon_rho');
%lat = nc_varget(grdfile,'lat_rho');
%mask = nc_varget(grdfile,'mask_rho');
lon = grd.lonr; lat = grd.latr; mask = grd.maskr;

% Mask out land points:
lon = lon.*mask;
lat = lat.*mask;
% Remove iskip points near the boundaries:
x = lon(iskip+1:dgrid:end-iskip,iskip+1:dgrid:end-iskip);
y = lat(iskip+1:dgrid:end-iskip,iskip+1:dgrid:end-iskip);
% Remove land points:
x = x(find(x~=0));
y = y(find(y~=0));
%figure; plot(x,y,'o'); axis equal; axis tight; % test

length(x)
% pick out small region with higher density of particles
reseed_pos = find(x<=-31.5&x>=-32&y>=-13.75&y<=-13.25);
sqrt(length(reseed_pos))
dx = mean(diff(lon(:,1)));
dy = mean(diff(lat(1,:)));
for xy = 1:length(reseed_pos)
    xini = x(reseed_pos(xy)); yini = y(reseed_pos(xy));
    x2 = xini + [0,dx/2,dx/2,0,dx/2,dx,dx,dx,dx,dx/2,0,-dx/2,-dx/2,-dx/2,-dx/2];
    y2 = yini + [dy/2,dy/2,0,dy,dy,dy,dy/2,0,-dy/2,-dy/2,-dy/2,-dy/2,0,dy/2,dy];
    x = cat(1,x,x2'); y = cat(1,y,y2');
end
length(x)

nfloats = length(x);
idfloat = 1:nfloats;
for it = 1:length(time0),
  lifetime_it = repmat(lifetime(it),[1 nfloats]);
  time = time0(it);
  dnvec = datevec(double(time)+TREF);
  for iz = 1:length(z0_2d),
    z0_2d_array = repmat(z0_2d(iz),[1 nfloats]);
    title = sprintf(['Isobaric particle information at release time '...
             '(z=%4.0f)'],z0_2d(iz));
    outfile = sprintf('%s/floats2d_z%02dm_releaseY%04dM%02dD%02d.nc%s',...
               outdir,-floor(z0_2d(iz)),dnvec(1),dnvec(2),dnvec(3),endf);
    create_ncfile_floats2d(nfloats,title,outfile);
    nc_varput(outfile,'floatid',idfloat');
    nc_varput(outfile,'lon',x');
    nc_varput(outfile,'lat',y');
    nc_varput(outfile,'z0',z0_2d_array');
    nc_varput(outfile,'lifetime',lifetime_it');
    nc_varput(outfile,'time',time);
  end % loop on initial 2d z-level

  title = '3d particle information at release time';
  outfile = sprintf('%s/floats3d_releaseY%04dM%02dD%02d.nc%s',...
             outdir,dnvec(1),dnvec(2),dnvec(3),endf);
  create_ncfile_floats3d(length(z0_3d),nfloats,title,outfile);
  nc_varput(outfile,'floatid',idfloat');
  nc_varput(outfile,'lon',permute(repmat(x,[1 1 length(z0_3d)]),[2 3 1]));
  nc_varput(outfile,'lat',permute(repmat(y,[1 1 length(z0_3d)]),[2 3 1]));
  nc_varput(outfile,'z',repmat(z0_3d,[1 1 length(idfloat)]));
  nc_varput(outfile,'lifetime',lifetime_it');
  nc_varput(outfile,'time',time);
end % loop on redeployment time time0
