function u_interp = interp_script(grd,maskr,masku,maskv,lon,lat,z,u,z_r,z_w,gswitch)
%%
%   u_interp = interp_script(grd,maskr,masku,maskv,lon,lat,z,u,z_r,z_w,gswitch)
%   
%   INPUT:
%       grd = grd-structure according to MANU-convention - variable u
%       maskr/u/v = 2D mask at rho/u/v-points - variable u
%       lon/lat = 2D grid - particle
%       z = particle depths
%       u = 3-D gridded variable to interpolate onto particle
%       z_r/z_w = depth at rho/w points - u
%       gswitch = 1(u-comp); 2(v-comp); 3(r-comp); u-grid type
%

%disp(['particle number = ',num2str(p)])
%tic;
if isnan(lon); return; end
[xrdel,xr] = find_index(grd.lonr(:,1),lon);
[yrdel,yr] = find_index(grd.latr(1,:),lat);
dr = [xrdel, yrdel];
% add line for rho variables
if gswitch == 1 % u
[xdel,x] = find_index(grd.lonu(:,1),lon);
[ydel,y] = find_index(grd.latu(1,:),lat);
d = [xdel, ydel];
mask = masku;
elseif gswitch == 2 % v
[xdel,x] = find_index(grd.lonv(:,1),lon);
[ydel,y] = find_index(grd.latv(1,:),lat);
d = [xdel, ydel];
mask = maskv;
else
x = xr; y = yr; d =dr; mask = maskr;
end

[~,zk1] = find_index(z_r(xr,yr,:),z);
[~,zw1] = find_index(z_w(xr,yr,:),z);

u_interp = 0; % if no particle or close to boundary

% loop to determine number of nearest neighbours
nn = nn_ct(maskr,xr,yr,zk1);

if nn == 64
    % do interpolation on depth variable first to find optimum layer
    % separate interpolation in z for w variables
    
    %rho-variables first
    %tic;
    if gswitch ~= 3
        for k = 1:grd.N
            zk_range(:,:,k) = z_r(xr-1:xr+2,yr-1:yr+2,k);
            % interpolate z in x,y
            z_int(k) = cubic_interp(zk_range(:,:,k),dr,2);
        end
        %toc;
        
        [zkdel, zk] = find_index(z_int,z);
        %disp(['zk1 - zk = ',num2str(zk1-zk)])
        
        nn = nn_ct(mask,x,y,zk);
        
        if nn == 64
            
            % do horizontal interpolation for all other variables
            k1 = 1;
            for k = zk-1:zk+2
                u_range(:,:,k1) = u(x-1:x+2,y-1:y+2,k);
                %v_range =
                % add other variables
                u_int(k1) = cubic_interp(u_range(:,:,k1),d,2);
                k1 = k1 +1;
            end
            
            % interpolate all variables in z
            u_interp = cubic_interp(u_int,zkdel,1);
            
        end
    else
        %w-variables
        for k = 1:size(z_w,3)
            zw_range(:,:,k) = z_w(xr-1:xr+2,yr-1:yr+2,k);
            z_int(k) = cubic_interp(zw_range(:,:,k),dr,2);
        end
        
        [zwdel, zw] = find_index(z_int,z);
        %disp(['zw1 - zw = ',num2str(zw1-zw)])
        
        nn = nn_ct(mask,x,y,zw);
        
        if nn == 64
            % do horizontal interpolation for all other variables
            k1 = 1;
            for k = zw-1:zw+2
                w_range(:,:,k1) = u(xr-1:xr+2,yr-1:yr+2,k);
                w_int(k1) = cubic_interp(w_range(:,:,k1),dr,2);
                k1 = k1 +1;
                %v_range =
                % add other variables
            end
            
            % interpolate all variables in z
            u_interp = cubic_interp(w_int,zwdel,1);
            
        end
        
        z_r = z_w;
    end
end

%interpolate the boundaries in z
if x >= 2 && x < size(mask,1)-1 && y >= 2 && y < size(mask,2)-1
    if z > z_r(xr,yr,end)
        zk = size(z_r,3);
        u_interp = cubic_interp(u(x-1:x+2,y-1:y+2,zk),d,2);
    elseif z < z_r(xr,yr,1)
        zk = 1;
        u_interp = cubic_interp(u(x-1:x+2,y-1:y+2,zk),d,2);
    end
end
%w_int(t,1,p) = cubic

end

    