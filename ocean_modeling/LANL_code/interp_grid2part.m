function interp_grid2part(grdnum,f,level)
%% Interpolation of eulerian field to particle coordinates
%

disp([grdnum f level])
if f == 1 && level > 1
    return;
end

HR_version = 2;
seas = 1; %% EDIT
clean = 1; % switch to save extra variable of mean interpolated variables

% Constants
if grdnum == 1;
    timestrvec = {'1999M08D01' '1999M11D01' '2000M02D01' '2000M05D01'};
    grd = rnt_gridload('soatl1');
elseif grdnum == 3;
    if HR_version == 1
        timestrvec = {'1999M08D01' '1999M09D01' '1999M10D01' '1999M11D01' '1999M12D01' '2000M01D01'...
            '2000M02D01' '2000M03D01' '2000M04D01' '2000M05D01' '2000M06D01' '2000M07D01'};
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
flstr = flstrvec{f};

%% My own bicubic interpolation in x,y; followed by cubic interpolation in z
% Follow the procedure in ashwan's code and test on the instantaneous
% velocities.

if seas == 0
% % annual
eulerian_data_path = '/atlas2/kjoshi36/LANL/eulerian_data/'; %EDIT
nce = netcdf([eulerian_data_path,'mean_grid',num2str(grdnum),'.nc']); %EDIT
ue = nce{'u'}(:);
ve = nce{'v'}(:);
we = nce{'w'}(:);
ue = permute(ue,[3,2,1]); %Manu convention
ve = permute(ve,[3,2,1]);
we = permute(we,[3,2,1]);
%zeta = nce{'zeta'}(:);
%zeta = zeta';
elseif seas == 1
% seasonal
% JJAS
seasonal_data_path = '/atlas2/kjoshi36/LANL/eulerian_data/'; %EDIT
nce = netcdf([seasonal_data_path,'mean_JJAS_grid',num2str(grdnum),'.nc']); %EDIT
ue1 = nce{'u'}(:);
ve1 = nce{'v'}(:);
we1 = nce{'w'}(:);
ue1 = permute(ue1,[3,2,1]); %Manu convention
ve1 = permute(ve1,[3,2,1]);
we1 = permute(we1,[3,2,1]);
% NDJFM
nce = netcdf([seasonal_data_path,'mean_NDJFM_grid',num2str(grdnum),'.nc']);
ue2 = nce{'u'}(:);
ve2 = nce{'v'}(:);
we2 = nce{'w'}(:);
ue2 = permute(ue2,[3,2,1]); %Manu convention
ve2 = permute(ve2,[3,2,1]);
we2 = permute(we2,[3,2,1]);
end
zeta = 0;
% 
z_r = permute(zlevs(grd.h,zeta,grd.thetas,grd.thetab,grd.hc,grd.N,'r'),[2,3,1]);
z_w = permute(zlevs(grd.h,zeta,grd.thetas,grd.thetab,grd.hc,grd.N,'w'),[2,3,1]);
%[z_r,z_w,~] = rnt_setdepth(0,grd);
maskr = repmat(grd.maskr,[1,1,grd.N]);
masku = repmat(grd.masku,[1,1,grd.N]);
maskv = repmat(grd.maskv,[1,1,grd.N]);

%clear nce ue1 ue2 ve1 ve2 we1 we2
if grdnum == 3 && HR_version == 1
    lagrangian_data_path = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/old_HR/';
else
    lagrangian_data_path = '/atlas2/kjoshi36/LANL/lagrangian_data/trajs_data/newHR/'; %% EDIT
end

for r = 64:length(timestrvec) % loop over release
%for r = 2; %EDIT
     
    timestr = timestrvec{r};
    
    lag_field = lag_load(grdnum,f,r,level,0);
    lon = lag_field.lon;
    lat = lag_field.lat;
    z = lag_field.z;
    if seas == 1;
        timevec = lag_field.datenum;
        [~,mo,~,~,~,~] = datevec(timevec);
        s1 = 6:9; s2 = [11,12,1,2,3];
    else mo = []; s1 = []; ue1 = []; ve1 = []; we1 = []; 
        s2 = []; ue2 = []; ve2 = []; we2 = [];
    end;
    
    tt = size(lon,1); pp = size(lon,3);
    % loop over time
    u_interp = zeros(tt,1,pp);
    v_interp = zeros(tt,1,pp);
    w_interp = zeros(tt,1,pp);

    disp(timestr)
    
    % loop to shorten high-res interpolation
    if grdnum == 3
        tsum = sq(sum(~isnan(lon),3));
        t_temp = find(tsum == 0,1,'first');
        if ~isempty(t_temp)
            tt = t_temp; 
        end
    end
    matlabpool(4)
    tic;
    parfor t = 1:tt
        disp(t)
        %% MIGHT HAVE TO COMMENT OUT THIS SECTION TO MAKE ANNUAL WORK
        if seas == 1
            if any(s1 == mo(t)); ue = ue1; ve = ve1; we = we1; 
            elseif any(s2 == mo(t)); ue = ue2; ve = ve2; we = we2;
            else continue;
            end
        end
        %% END SECTION
        
        % loop over all particles
        for p = 1:pp % ~20s
            if isnan(lon(t,1,p)); continue; end
            u_interp(t,1,p) = interp_script(grd,maskr,masku,maskv,...
                lon(t,1,p),lat(t,1,p),z(t,1,p),ue,z_r,z_w,1);
            v_interp(t,1,p) = interp_script(grd,maskr,masku,maskv,...
                lon(t,1,p),lat(t,1,p),z(t,1,p),ve,z_r,z_w,2);
            w_interp(t,1,p) = interp_script(grd,maskr,masku,maskv,...
                lon(t,1,p),lat(t,1,p),z(t,1,p),we,z_r,z_w,3);
        end;
    end
    toc;
    matlabpool close 
    
    if clean
        disp('adding interpolated field')
        lfile = [lagrangian_data_path,'floats',flstr,'_releaseY',timestr,...
            '_out.nc.',num2str(grdnum)];
        nc = netcdf(lfile,'w');
        if seas == 0
        nc{'umean'} = ncfloat('time','ilevel','ifloat');
        nc{'umean'}.long_name = ncchar('Mean u-component interpolated onto particle');
        nc{'umean'}.units = ncchar('ms-1');
        nc{'vmean'} = ncfloat('time','ilevel','ifloat');
        nc{'vmean'}.long_name = ncchar('Mean v-component interpolated onto particle');
        nc{'vmean'}.units = ncchar('ms-1');
        nc{'wmean'} = ncfloat('time','ilevel','ifloat');
        nc{'wmean'}.long_name = ncchar('upward velocity interpolated onto particle');
        nc{'wmean'}.units = ncchar('ms-1');
        elseif seas == 1
        nc{'useas'} = ncfloat('time','ilevel','ifloat');
        nc{'useas'}.long_name = ncchar('Seasonal mean u-component interpolated onto particle');
        nc{'useas'}.units = ncchar('ms-1');
        nc{'vseas'} = ncfloat('time','ilevel','ifloat');
        nc{'vseas'}.long_name = ncchar('Seasonal mean v-component interpolated onto particle');
        nc{'vseas'}.units = ncchar('ms-1');
        nc{'wseas'} = ncfloat('time','ilevel','ifloat');
        nc{'wseas'}.long_name = ncchar('Seasonal mean upward velocity interpolated onto particle');
        nc{'wseas'}.units = ncchar('ms-1');
        end
        endef(nc)
        if seas == 0
        nc{'umean'}(:,level,:) = u_interp;
        nc{'vmean'}(:,level,:) = v_interp;
        nc{'wmean'}(:,level,:) = w_interp;   
        elseif seas == 1
        nc{'useas'}(:,level,:) = u_interp;
        nc{'vseas'}(:,level,:) = v_interp;
        nc{'wseas'}(:,level,:) = w_interp;
        end
        close(nc)
    end  
end

end
