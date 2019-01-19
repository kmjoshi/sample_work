function create_ncfile_floats3d(nlevels,nfloats,title,outfile)

% Create the output file:
nc_create_empty(outfile);

% Create dimensions:
nc_add_dimension(outfile,'ilevel',nlevels);
nc_add_dimension(outfile,'ifloat',nfloats);
nc_add_dimension(outfile,'time',0);

%  Create variables:
var = 'floatid';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'ifloat'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Particle id number');
nc_attput(outfile,var,'units','nondimensional');

var = 'lon';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'time','ilevel','ifloat'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Longitude of particle trajectory');
nc_attput(outfile,var,'units','degrees_east');
nc_attput(outfile,var,'field','lon, scalar, series');

var = 'lat';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'time','ilevel','ifloat'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Latitude of particle trajectory');
nc_attput(outfile,var,'units','degrees_north');
nc_attput(outfile,var,'field','lat, scalar, series');

var = 'z';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'time','ilevel','ifloat'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Depth of particle trajectory');
nc_attput(outfile,var,'units','m');
nc_attput(outfile,var,'field','z (negative), scalar, series');

var = 'lifetime';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'ifloat'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Particle total duration');
nc_attput(outfile,var,'units','days');

var = 'time';
varstruct.Name = var;
varstruct.Nctype = 'double';
varstruct.Dimension = {'time'};
nc_addvar(outfile,varstruct);
nc_attput(outfile,var,'long_name','Lagrangian time');
nc_attput(outfile,var,'units','days since 1990-01-01 00:00:00 GMT');
nc_attput(outfile,var,'calendar','gregorian');

%  Create some global attributes:
logname = sprintf('%s',evalc('!whoami'));
logname = logname(1:end-1); % end-1 to drop \n at end
nc_attput(outfile,nc_global,'author',logname);
nc_attput(outfile,nc_global,'date',date);
nc_attput(outfile,nc_global,'title',title);

return
