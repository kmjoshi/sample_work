%% Script to interpolate onto the new HR grid data
%

for g = 3
for f = 2
for l = [1,2,3,4]
%for s = 1:2
	%vel_autocorr_seas_bc1(g,f,l,s)
	%abs_dispersion_uvw_seas_bc(g,f,l,s)
	%rel_dispersion_2(g,f,l,0)
	%tpart_stats(g,f,l,0,'dispersion')
	%tpart_stats(g,f,l,0,'fsle')
	%tpart_stats(g,f,l,0,'ftle')
    interp_grid2part(g,f,l)
end
end
end
%end

%for g = [1]
%for f = 2
%for l = 1:4
%	rel_dispersion_w(g,f,l,0)
%	tpart_stats(g,f,l,0,'dispersion',1)
%      tpart_stats(g,f,l,0,'fsle',1)
%       tpart_stats(g,f,l,0,'ftle',1)
%end
%end
%end


