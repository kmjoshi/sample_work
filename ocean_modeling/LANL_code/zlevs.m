function z = zlevs(h,zeta,theta_s,theta_b,hc,N,type);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  function z = zlevs(h,zeta,theta_s,theta_b,hc,N,type);
%
%  this function compute the depth of rho or w points for ROMS
%
%  On Input:
%
%    type    'r': rho point 'w': w point 
%
%  On Output:
%
%    z       Depths (m) of RHO- or W-points (3D matrix).
% 
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%  
%  This file is part of ROMSTOOLS
%
%  ROMSTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  ROMSTOOLS is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2002-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M,L]=size(h);
%
% Set S-Curves in domain [-1 < sc < 0] at vertical W- and RHO-points.
%
if type=='w'
  sc=((0:N)-N)/N;
  N=N+1;
else
  sc=((1:N)-N-0.5)/N;
end

Aweight=1.0;
Bweight=1.0;
if theta_s>0.0,
  Csur=(1.0-cosh(theta_s*sc))./(cosh(theta_s)-1.0);
  if theta_b>0.0,
    Cbot=sinh(theta_b*(sc+1.0))./sinh(theta_b)-1.0;
    Cweight=(sc+1.0).^Aweight.*(1.0 +               ...
                                (Aweight/Bweight)*(1.0-(sc+1.0).^Bweight));
    Cs=Cweight.*Csur+(1.0-Cweight).*Cbot;
  else
    Cs=Csur;
  end
else
  Cs=sc;
end
%
% Create S-coordinate system: based on model topography h(i,j),
% fast-time-averaged free-surface field and vertical coordinate
% transformation metrics compute evolving depths of of the three-
% dimensional model grid.
%    
hinv=1./(hc+h);
cff=hc*sc;
cff1=Cs;
z=zeros(N,M,L);
for k=1:N
  cff2=(cff(k)+cff1(k)*h).*hinv;
  z(k,:,:)=zeta+(zeta+h).*cff2;
end

return
