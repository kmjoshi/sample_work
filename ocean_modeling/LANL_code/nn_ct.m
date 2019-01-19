function nn = nn_ct(mask,ix,iy,iz)
%% Count total number of valid neighbours that are not NaNs
%   
%   INPUT: mask
%          ix,iy, iz
%

nn = 0;
if ix >= 2 && ix < size(mask,1)-1 && iy >= 2 && iy < size(mask,2)-1 &&...
    iz >= 2 && iz < size(mask,3) - 1
nn = sum(sum(sum(mask(ix-1:ix+2,iy-1:iy+2,iz-1:iz+2))));
end

end

