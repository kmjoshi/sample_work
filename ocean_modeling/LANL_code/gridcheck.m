function [lonr,latr,maskr] = gridcheck(grd,field)

[I,J]=size(field);
grtype='r';
if (I == grd.L & J == grd.M) , grtype ='p'; end
if (I == grd.Lp & J == grd.M) , grtype ='v'; end
if (I == grd.L & J == grd.Mp) , grtype ='u'; end

if grtype == 'r'; lonr=grd.lonr; latr=grd.latr; maskr=grd.maskr; end 
if grtype == 'p'; lonr=grd.lonp; latr=grd.latp; maskr=grd.maskp; end 
if grtype == 'v'; lonr=grd.lonv; latr=grd.latv; maskr=grd.maskv; end
if grtype == 'u'; lonr=grd.lonu; latr=grd.latu; maskr=grd.masku; end

end