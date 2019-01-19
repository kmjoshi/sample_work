function output = cubic_interp(in,d,dim)
%%  Used in INTERP_SCRIPT.M 
%   output = cubic_interp(in,d,dim)
%   INPUT:  
%       in = values to interpolate
%       d = vector of distance between data and grid-point (x,y,z)
%       dim = dimensions of destination grid

% input (4,4,n) looped over levels?
if dim == 1
    output = cubic_1(in,d);
elseif dim == 2
    for i = 1:4
    outxd(i) = cubic_1(in(:,i),d(1));
    end
    output = cubic_1(outxd,d(2));
elseif dim == 3
    for i = 1:4
        for j = 1:4
            outxd(i,j) = cubic_1(in(:,i,j),d(1));
        end
    end
    for i = 1:4
        outyd(i) = cubic_1(in(:,i),d(2));
    end
    output = cubic_1(outyd,d(3));
end

end


function out = cubic_1(in,d) % ashwanth
out = 0.5*(in(2)+in(3)) + (d-0.5)*(in(3)-in(2)) + (d/4)*(d-1)*(in(4)-in(3)+in(1)-in(2))...
    +(1/6)*(d-0.5)*d*(d-1)*(in(4)-in(3)-2*(in(3)-in(2))+in(2)-in(1));
end

function out = cubic_2(in,d) % paulbourke.net
a0 = in(4) - in(3) - in(1) + in(2);
a1 = in(1) - in(2) - a0;
a2 = in(3) - in(1);
a3 = in(2);

out = a0*d^3 + a1*d^2 + a2*d + a3;
end

function out = cubic_3(in,d) % paulinternet catrum roll spines with coefficients
a0 = (1/2)*in(4) - (3/2)*in(3) - (1/2)*in(1) + (3/2)*in(2);
a1 = -(1/2)*in(4) + 2*in(3) - (5/2)*in(2) + in(1);
a2 = (1/2)*in(3) - (1/2)*in(1);
a3 = in(2);

out = a0*d^3 + a1*d^2 + a2*d + a3;
end
