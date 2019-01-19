%(R)oms (N)umerical (T)oolbox
%ad(nameit);

%
% FUNCTION grdinfo = rnt_gridinfo(gridid)
%
% Loads the grid configuration for gridid
% To add new grid please edit this file.
% just copy an existing one and modify for
% your needs. It is simple.
%
% If you editing this file after using
% the Grid-pak scripts use the content
% of variable "nameit" for gridid.
%
% Example: CalCOFI application
%
%    grdinfo = rnt_gridinfo('calc')
%
% RNT - E. Di Lorenzo (edl@gatech.edu)

function gridindo=rnt_gridinfo(gridid)
  
% initialize to defaults
  gridindo.id      = gridid;
  gridindo.name    = '';
  gridindo.grdfile = '';
  gridindo.N       = 20;
  gridindo.thetas  = 5;
  gridindo.thetab  = 0.4;
  gridindo.tcline  = 200;
  gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');
  
  if exist(gridid)== 2
     file = textread(gridid,'%s','delimiter','\n','whitespace','');
     for i=1:length(file)
       eval(file{i});
     end
     return
  end
  
  switch gridid

  case 'soatl1'
        gridindo.id      = gridid;
	gridindo.name    = 'South Atlantic 1';
	gridindo.grdfile = '/nas/kjoshi36/matlib/grids/soatl25km_r0.2_grd.nc.1';
	gridindo.N       = 60;
	gridindo.thetas  = 5;
	gridindo.thetab  = 0;
	gridindo.hc      = 10;
    gridindo.tcline  = 200;
% 	gridindo.tcline  = 50;

  case 'soatl2'
        gridindo.id      = gridid;
	gridindo.name    = 'South Atlantic 2';
	gridindo.grdfile = '/nas/kjoshi36/matlib/grids/soatl25km_r0.2_grd.nc.2';
	gridindo.N       = 60;
	gridindo.thetas  = 5;
	gridindo.thetab  = 0;
	gridindo.hc      = 10;
    gridindo.tcline  = 200;
% 	gridindo.tcline  = 50;
      
      case 'soatl3'
        gridindo.id      = gridid;
	gridindo.name    = 'South Atlantic 3';
	gridindo.grdfile = '/nas/kjoshi36/matlib/grids/soatl25km_r0.2_grd.nc.3';
	gridindo.N       = 60;
	gridindo.thetas  = 5;
	gridindo.thetab  = 0;
	gridindo.hc      = 10;
    gridindo.tcline  = 200;
% 	gridindo.tcline  = 50;
      
      case 'wrd'
    gridindo.id      = gridid;
    gridindo.name    = 'World';
    gridindo.grdfile = which('wrd-grid.nc');
    gridindo.N       = 10;
    gridindo.thetas  = 3;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.tcline  = 50;

  case 'natl'
    gridindo.id      = gridid;
    gridindo.name    = 'North Atlantic  ';
    gridindo.grdfile = '/sdb/edl/ROMS-pak/natl-data/NATL_grid_1c.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab10'
	  gridindo.id      = gridid; 
  	gridindo.name    = 'lab10'; 
  	gridindo.grdfile = '/neo/ROMS_Tutorial/main-nested-lab/lab10-grid.nc'; 
  	gridindo.N       = 30; 
  	gridindo.thetas  = 5; 
  	gridindo.thetab  = 0.4; 
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

    case 'lab11'
    gridindo.id      = gridid;
    gridindo.name    = 'lab11';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/lab11/lab11-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

    case 'lab11_3'
    gridindo.id      = gridid;
    gridindo.name    = 'lab11_3';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/lab11/lab11_3-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

    case 'lab11_1'
    gridindo.id      = gridid;
    gridindo.name    = 'lab11_01';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab11_1-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

    case 'lab11_2'
    gridindo.id      = gridid;
    gridindo.name    = 'lab11_2';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab11_2-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab12'
    gridindo.id      = gridid;
    gridindo.name    = 'lab12';
    %gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab12-grid.nc';
    gridindo.grdfile = '/clima/haoluo/nas/haoluo/input/Newtopo_75to05/v64/lab12-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'gom5hao'
    gridindo.id      = gridid;
    gridindo.name    = 'Parent hc=10';
    gridindo.grdfile = ('/nas/haoluo/AGRIF/gom5km-grid.nc');
    gridindo.N       = 70;
    gridindo.hc      = 10;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'subgom'
    gridindo.id      = gridid;
    gridindo.name    = 'Parent hc=10';
    gridindo.grdfile = ('/nas/haoluo/AGRIF/gom5km-subgrid.nc');
    gridindo.N       = 70;
    gridindo.hc      = 10;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'gom5hao1'
    gridindo.id      = gridid;
    gridindo.name    = 'Parent hc=10';
    gridindo.grdfile = ('/nas/haoluo/AGRIF/gom5km-grid.nc');
    gridindo.N       = 35;
    gridindo.hc      = 10;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'subgom1'
    gridindo.id      = gridid;
    gridindo.name    = 'Parent hc=10';
    gridindo.grdfile = ('/nas/haoluo/AGRIF/gom5km-subgrid.nc');
    gridindo.N       = 35;
    gridindo.hc      = 10;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'gom5yuley'
    gridindo.id      = gridid;
    gridindo.name    = 'Parent hc=10';
    gridindo.grdfile = ('/nv/pe1/hluo33/GoMx/input/gom5km-grid.nc');
    gridindo.N       = 35;
    gridindo.hc      = 10;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.2;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'coral1k'
    gridindo.id      = gridid;
    gridindo.name    = 'Northern GoMx 1km rectangular ';
    gridindo.grdfile = ('/nas/yuley/Corals_GoMx/coral1-grid.nc');
    gridindo.N       = 40;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.2;
    gridindo.hc      = 5;
%    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'pac50'
    gridindo.id      = gridid;
    gridindo.name    = 'pac50';
    gridindo.grdfile = '/clima/haoluo/nas/PACIFIC/50km/pac50-grid.nc';
    gridindo.N       = 40;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');
 
  case 'pac501'
    gridindo.id      = gridid;
    gridindo.name    = 'pac50';
    gridindo.grdfile = '/clima/haoluo/nas/PACIFIC/50km/wrong/pac50-grid.nc';
    gridindo.N       = 40;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');
 
  case 'pac25'
    gridindo.id      = gridid;
    gridindo.name    = 'pac25';
    gridindo.grdfile = '/clima/haoluo/nas/PACIFIC/25km/pac25-grid.nc';
    gridindo.N       = 40;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab12mv'
    gridindo.id      = gridid;
    gridindo.name    = 'lab12mv';
    %gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab12-grid.nc';
    gridindo.grdfile = '/nas/haoluo/input/Newtopo_75to05/v64/lab12-grid.nc';
    gridindo.N       = 60;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab12lv'
    gridindo.id      = gridid;
    gridindo.name    = 'lab12lv';
    %gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab12-grid.nc';
    gridindo.grdfile = '/nas/haoluo/input/Newtopo_75to05/v64/lab12-grid.nc';
    gridindo.N       = 15;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab13'
    gridindo.id      = gridid;
    gridindo.name    = 'lab13';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/input/lab13-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

   case 'lab121'
    gridindo.id      = gridid;
    gridindo.name    = 'lab121';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/lab12_new/lab121-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'lab10_5'
    gridindo.id      = gridid;
    gridindo.name    = 'lab10_5';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/lab10/lab10_5-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'ias20'
    gridindo.id      = gridid;
    gridindo.name    = 'Intra-america-sea 20km';
    gridindo.grdfile = which('ias20_grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.hc  = 20.;
    gridindo.cstfile ='ias_coast.mat';
    
  case 'northsea'
    gridindo.id      = gridid;
    gridindo.name    = 'North Sea';
    gridindo.grdfile = which('northsea-grid.nc');
    gridindo.N       = 25;
    gridindo.thetas  = 3;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');
 
  case 'crd_10km'
    gridindo.id      = gridid;
    gridindo.name    = 'crd_10km';
    gridindo.grdfile = '/nv/pe1/hluo33/TTD_10km/crd_10km-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

  case 'crttd_10km'
    gridindo.id      = gridid;
    gridindo.name    = 'crttd_10km';
    gridindo.grdfile = '/data/nas/haoluo/crttd_10km/crttd-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.tcline  = 200;
    gridindo.cstfile = which('rgrd_CoastlineWorld.mat');

           
  case 'china25'
    gridindo.id      = gridid;
    gridindo.name    = 'East China Sea 25 km';
    gridindo.grdfile = which('china-grid.nc');
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'cb'
    gridindo.id      = gridid;
    gridindo.name    = 'CB';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/cb/input/cb-grid.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'hab'
    gridindo.id      = gridid;
    gridindo.name    = 'CB';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/cb/input/grid_HABFL3D_EWSobc.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = '/neo/GFD_Class/gfd_root/roms-examples/cb/input/HABFL3D_EWSobc_coast.mat';

  case 'ias10'
    gridindo.id      = gridid;
    gridindo.name    = 'IAS10';
    gridindo.grdfile = '/drive/dana/IAS10/10km/ias10-manu-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'pac251'
    gridindo.id      = gridid;
    gridindo.name    = 'Pacific';
    gridindo.grdfile = which('pac25-grid.nc');
    gridindo.N       = 40;
    gridindo.thetas  = 6;
    gridindo.hc  = 50;
    gridindo.thetab  = 0.0;

  case 'pacific10'
    gridindo.id      = gridid;
    gridindo.name    = 'Pacific 10km';
    gridindo.grdfile = '/nas/haoluo/PACIFIC/pacific-grid.nc';
    gridindo.N       = 40;
    gridindo.thetas  = 6;
    gridindo.hc  = 50;
    gridindo.thetab  = 0.0;

  case 'npacifich'
    gridindo.id      = gridid;
    gridindo.name    = 'South Pacific';
    gridindo.grdfile = which('npacific');
    gridindo.N       = 30;
    gridindo.thetas  = 6;
    gridindo.hc  = 50;
    gridindo.thetab  = 0.0;

  case 'npacific'
    gridindo.id      = gridid;
    gridindo.name    = 'North Pacific';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/npacific/input/npacific-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.hc  = 30;
    gridindo.thetab  = 0.4;

  case 'ccs-periodic'
    gridindo.id      = gridid;
    gridindo.name    = 'CCS Periodic';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/ccs_periodic/input/ccs-periodic-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.hc  = 30;
    gridindo.thetab  = 0.4;

  case 'ccs-periodic_J'
    gridindo.id      = gridid;
    gridindo.name    = 'CCS Periodic';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/ccs_periodic/input/ccs-periodic-grid_J.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.hc  = 30;
    gridindo.thetab  = 0.4;
    gridindo.cstfile = '/neo/GFD_Class/gfd_root/roms-examples/ccs_periodic/input/ccs_per_coast.mat';

 case 'np6'
    gridindo.id      = gridid;
    gridindo.name    = 'Pacific';
    gridindo.grdfile = '/neo/GFD_Class/hyodae/npac/roms-NP6-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.hc  = 30;
    gridindo.thetab  = 0.4;


  case 'bc'
    gridindo.id      = gridid;
    gridindo.name    = 'British Columbia';
    gridindo.grdfile = which('bc-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5.0;
    gridindo.hc  = 20;
    gridindo.thetab  = 0.4;

  case 'so'
    gridindo.id      = gridid;
    gridindo.name    = 'Southern Ocean';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-grid/so-grid.nc';
    gridindo.N       = 1;
    gridindo.thetas  = 5.0;
    gridindo.hc  = 20;
    gridindo.thetab  = 0.4;


  case 'gulfs'
    gridindo.id      = gridid;
    gridindo.name    = 'Gulf Stream coarse';
    gridindo.grdfile = which('gulfs-grid.nc');
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.hc  = 20;
    gridindo.thetab  = 0.4;


  case 'indian'
    gridindo.id      = gridid;
    gridindo.name    = 'Indian Ocean';
    gridindo.grdfile = which('indian-grid.nc');
    gridindo.N       = 20;
    gridindo.thetas  = 6;
    gridindo.thetab  = 0.0;

case 'indo-pac'
    gridindo.id      = gridid;
    gridindo.name    = 'Indo-pacific';
    gridindo.grdfile = which('indo-pac-grid.nc');
    gridindo.N       = 20;
    gridindo.thetas  = 6;
    gridindo.thetab  = 0.0;

  case 'nepd'
    gridindo.id      = gridid;
    gridindo.name    = 'NEPD-GOA-CCS grid';
    gridindo.grdfile = which('nepd-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'tp'
    gridindo.id      = gridid;
    gridindo.name    = 'Tropical Pacific';
    gridindo.grdfile = which('tp-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

 case 'tpc'
    gridindo.id      = gridid;
    gridindo.name    = 'Tropical Pacific';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/tropical_pacific/input/tpc-grid.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

 case 'tpacific'
    gridindo.id      = gridid;
    gridindo.name    = 'Tropical Pacific';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/tropical_pacific/input/tpacific-grid.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;



  case 'peru'
    gridindo.id      = gridid;
    gridindo.name    = 'Peru grid 20 Km';
    gridindo.grdfile = '/neo/ROMS_Tutorial/main-nested-peru/peru-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'pcs'
    gridindo.id      = gridid;
    gridindo.name    = 'Peru grid 20 Km';
    gridindo.grdfile = '/neo/ROMS_Tutorial/main-nested-peru/pcs-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'scb'
    gridindo.id      = gridid;
    gridindo.name    = 'SCB 7 km';
    gridindo.grdfile = which('scb-grid.nc');
    gridindo.N       = 20;
    gridindo.thetas  = 6.5;
    gridindo.thetab  = 0;
    gridindo.hc  = 155.6225;
    gridindo.cstfile = which('rgrd_CCS_CstLine.mat');

  case 'nep10'
    gridindo.id      = gridid;
    gridindo.name    = 'NEP 10 km new';
    gridindo.grdfile = which('nep10-grid.nc');
    gridindo.N       = 42;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridinfo.Tcline  = 50;
    gridinfo.hc      = 30;
 
 case 'world1'
    gridindo.id      = gridid;
    gridindo.name    = 'WORLD 25 km';
    gridindo.grdfile = '/data/nas/haoluo/PACIFIC/ROMS_ORCA025_grid_v2.nc';
    gridindo.N       = 50;
    gridindo.thetas  = 7;
    gridindo.thetab  = 2;
    gridinfo.Tcline  = 250;
    gridinfo.hc      = 250;
   
 case 'mini10'
    gridindo.id      = gridid;
    gridindo.name    = 'NEP 10 km new';
    gridindo.grdfile = '/neo/ROMS_Tutorial/mini10-data/mini10-grid.nc';
    gridindo.N       = 42;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridinfo.Tcline  = 50;
    gridinfo.hc      = 30;
    
  case 'ccs10'
    gridindo.id      = gridid;
    gridindo.name    = 'CCS extract of NEP 10 km new';
    gridindo.grdfile = which('ccs10-grid.nc');
    gridindo.N       = 42;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridinfo.Tcline  = 50;
    gridinfo.hc      = 30;

  case 'crttd'
    gridindo.id      = gridid;
    gridindo.name    = 'crttd 10km grid';
    gridindo.grdfile = '/nas/haoluo/crttd_10km/crttd-grid.nc';
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'nepd-ccs'
    gridindo.id      = gridid;
    gridindo.name    = 'NEPD-CCS grid';
    gridindo.grdfile = which('nepd-ccs-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;

  case 'nepd2x'
    gridindo.id      = gridid;
    gridindo.name    = 'CCS grid';
    gridindo.grdfile = which('nepd2x-grid.nc');
    gridindo.N       = 30;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;    

  case 'coriolis'
    gridindo.id      = gridid;
    gridindo.name    = 'Coriolis Inertial Oscillation';
    gridindo.grdfile = '/neo/GFD_Class/gfd_root/roms-examples/coriolis/input/coriolis-grid.nc';
    gridindo.N       = 16;
    gridindo.thetas  = 0;
    gridindo.thetab  = 0;
    gridindo.cstfile = which('rgrd_WorldCstLinePacific.mat');

  case 'shallow2d'
    gridindo.id      = gridid;
    gridindo.name    = 'Shallow 2D Oscillation';
    gridindo.grdfile = '/neo/GFD_Class/haoluo/roms-examples/shallow2D/input/shallow2d-grid.nc';
    gridindo.N       = 20;
    gridindo.thetas  = 0;
    gridindo.thetab  = 0;

  case 'test'
    gridindo.id      = gridid;
    gridindo.name    = 'Test west of florida';
    gridindo.grdfile = which('test-grid.nc');
    gridindo.N       = 40;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridinfo.Tcline  = 200;
   %gridinfo.hc      = 30;

   case 'gomx'
    gridindo.id      = gridid;
    gridindo.name    = 'GOM onlysouth';
    gridindo.grdfile = which('gomx-grid.nc');
    gridindo.N       = 70;
    gridindo.thetas  = 5;
    gridindo.thetab  = 0.4;
    gridinfo.Tcline  = 200;
    %gridinfo.hc      =10;
    
      case 'goma'
          gridindo.id      = gridid;
          gridindo.name    = 'GOM onlysouth';
          gridindo.grdfile = which('goma-grid.nc');
          gridindo.N       = 70;
          gridindo.thetas  = 5;
          gridindo.thetab  = 0.4;
          gridinfo.Tcline  = 200;
          %gridinfo.hc      =10;
          
      case 'gom5k'
          gridindo.id      = gridid;
          gridindo.name    = 'gom5k';
          gridindo.grdfile = which('gom5k-grid.nc');
          gridindo.N       = 70;
          gridindo.hc      = 10;
          gridindo.thetas  = 5;
          gridindo.thetab  = 0.4;
          gridindo.cstfile = which('rgrd_CoastlineWorld.mat');
          
      case 'test2newzealand'
          gridindo.id      = gridid;
          gridindo.name    = 'test2newzealand';
          gridindo.grdfile = which('test2newzealnd-grid.nc');
          gridindo.N       = 70;
          gridindo.hc      = 10;
          gridindo.thetas  = 5;
          gridindo.thetab  = 0.4;
          gridindo.cstfile = which('rgrd_CoastlineWorld.mat');
          
      case 'gom03_tamu'
          gridindo.id      = gridid;
          gridindo.name    = 'GOM 3KM 150 layer TAMU';
          gridindo.grdfile = '/atlas1/kjoshi36/gom_roms_setup/input/gom03_grd_N150.nc';
          gridindo.N       = 150;
          gridindo.hc      = 400;
          gridindo.thetas  = 10;
          gridindo.thetab  = 2;
          gridindo.cstfile = which('rgrd_CoastlineWorld.mat');          
          
      case 'gom01_tamu'
          gridindo.id      = gridid;
          gridindo.name    = 'GOM 1KM 50 layer TAMU';
          gridindo.grdfile = '/atlas1/kjoshi36/gom_roms_setup/1km_run/input/gom01_grd_N050.nc';
          gridindo.N       = 50;
          gridindo.hc      = 400;
          gridindo.thetas  = 10;
          gridindo.thetab  = 2;
          gridindo.cstfile = which('rgrd_CoastlineWorld.mat');          
    
      case 'gom01_tamu_etopo2'
          gridindo.id      = gridid;
          gridindo.name    = 'GOM 1KM 50 layer TAMU ETOPO2';
          gridindo.grdfile = '/atlas1/kjoshi36/gom_roms_setup/1km_run/input/gom01_cdx_grd_etopo2_R04_smooth_rx1_07.nc';
          gridindo.N       = 50;
          gridindo.hc      = 400;
          gridindo.thetas  = 10;
          gridindo.thetab  = 2;
          gridindo.cstfile = which('rgrd_CoastlineWorld.mat');          

          % PLEASE DO NOT EDIT BELOW THIS STRING - END_OF_CONFIG
          
      otherwise
          if ~strcmp(gridid,'default')
              error([' RNT_GRIDINFO - ',gridid,' not configured']);
          end
  end

