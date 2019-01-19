%%  lagrangian scripts list
%  
%%  Universal variables
%   
%   grdnum => 1 = LR; 3 = HR
%   f <=> flstr => 1 = 2d_z15m; 2 = 3d
%   t <=> timestr => index in release vector, which release file to load
%   level => 1 = 15m; 2 = 30m; 3 = 45m; 4 = 150m
%   seas_in => 0 = annual; 1-12 pick any months
%
%%  Setup
%
%   create_ncfile_floats2d.m => create the template 2D floats input file
%   create_ncfile_floats3d.m => similar for 3D
%
%   make_ic.m => make initial condition, insert particles
%
%%  Pre-processing
% 
%   interp_grid2part(grdnum,f,level) => interpolate velocity annual and
%   seasoanl means to particle positions 
%
%   interp_script.m => Interpolate any variable from a gridded field onto
%   the lagrangian particle positions
%   u_interp = interp_script(grd,maskr,masku,maskv,lon,lat,z,u,z_r,z_w,gswitch)
%
%
%   lag_load2.m => Load all important variables from lagrangian ouput
%    nc-files into MATLAB structures
%    (different from lag_load.m by a filepath definition)
%   lag_struct = lag_load(grdnum,f,t,level,seas_in,varargin)
%
%   interp_nohup_script.m => sample script to loop through a ton of
%   pre-processing
%   
%%  Analysis   
%   
%   lag_tot_obs_seasswitch.m => calculate the number of observations for
%    every release also separates releases into seasons
%   lag_tot_obs_seasswitch(grdnum,f,level,seas_in)
%   
%   lagrangian_means.m => calculate lagrangian binned means for several
%    variables over defined mxn bins
%   lagrangian_means(grdnum,f,level,seas_in)
%    saves a filename = ['lag_means_0.25deg',flstr,'_',num2str(grdnum),num2str(level),seas_str]
%
%   lag_means_plot.m => to plot output of lagrangian_means.m
%   lag_means_plot(g,fl,l,seas_in,ifsave)
%
%   particle_stats2.m => calculate and plot particle statistics such as average
%    depth, lifetime etc
%   particle_stats2(f,level)
%
%   lag_spectra_seas.m => calculate spectra of lagrangian particle velocity 
%    components, w/bandpass
%   lag_spectra_seas(grdnum,f,level,seas)
%
%   vel_autocorr_seas_bc1.m => calculate and plot velocity
%    autocorrelations, seasonal with bandpass
%   vel_autocorr_seas_bc1(grdnum,f,level,seas)
%   
%   abs_dispersion_uvw_seas_bc.m => calculate single=particle absolute
%    dispersion in mat-files for every release/depth/resolution with
%    bandpass-filtering and using a subsection for LR
%   abs_dispersion_uvw_seas_bc(grdnum,f,level,seas)
%
%   abs_dispersion_uvw_seas2.m => calculate single=particle absolute
%    dispersion in mat-files for every release/depth/resolution for whole
%    domain without filtering
%   abs_dispersion_uvw_seas2.m(grdnum,f,level,seas)
%   
%   rel_dispersion_seas.m => calculate relative dispersion for uv
%   rel_dispersion_seas(grdnum,f,level,seas_in)
%
%   rel_dispersion_w.m => calculate relative dispersion for w
%   rel_dispersion_w(grdnum,f,level,seas_in)
%
%   tpart_stats.m => use output from rel_dispersion_2.m to calculate
%    various 2-particle statistics in mat-files, also basic plotting
%   tpart_stats(grdnum,f,level,seas_in,stat,varargin) 
%   stat = 'dispersion' 'ftle' or 'fsle'
%   
%  
%%  Plotting (several are built-in to analysis scripts)
%
%   plot_trajs.m => function to make gifs of particle positions in
%    time, overlaid with depth
%
%   plot_trajs_var.m => function to make gifs of particle positions in
%    time, overlaid with color of any variable
%
%   plot_mean_streamslice.m => plot mean eulerian velocity fields
%   plot_mean_streamslice(grdnum,depthin) 
%
%   spaghetti_plot.m => make a spaghetti plot of trajectories
%   spaghetti_plot(grdnum,f,level,r)
%   
%   abs_dispersion_plotting_br.m => Plot absolute dispersion curves for
%   annual, seasonal and any mat-files stored as per abs_dispersion scripts
%
%   rel_dispersion_plotting => plot relative dispersion stats for any
%   release (manual)
%
%   FTLE_FSLE.m => plot individual FTLE/FSLE maps
%   FTLE_FSLE(grdnum,f,r,level,seas_in,le,le_num,varargin)
%
%   FTLE_FSLE_subplot.m => combine above maps
%   FTLE_FSLE_subplot(grdnum,rr,le,le_num,ifsave)
%
%%  Miscellaneous code
%
% % TOOLS:
%   find_index.m => find closest grid-point to particle location, used in
%   interpolation script interp_script.m
%   [delta,pindex] = find_index(ind_vec,ind)
%  
%   nn_ct.m => count neighbouring particles, used in interp_script.m
%   nn = nn_ct(mask,ix,iy,iz)
%
%   cubic_interp.m => cubic interpolation calculation used in
%   interp_script.m
%
%   area_norm(x,y) => simple normalization see below
%   out = y/trapz(x,y)
%   
%   zlevs.m => sigma to z-coordinate interpolation
%   also check roms_zlev.m (all z-coordinate transformations)
%
%   Using Manu's RNT Toolbox
%   Codes attached that are used in some of the above functions
%
%   rnt_gridload.m => load grid-structure containing relevant information
%   for each grid-file stored in rnt_gridinfo.m
%
%   gridcheck.m => check which type of grid-variable (rho,psi,u,v)
%   [lonr,latr,maskr] = gridcheck(grd,field)
%   
%   fftseries.m => calculate normalized spectra
%
%