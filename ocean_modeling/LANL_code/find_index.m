function [delta,pindex] = find_index(ind_vec,ind)
%%  Used in INTERP_SCRIPT.M
%   [delta,pindex] = find_index(ind_vec,ind)
[~,index] = min(abs(ind - ind_vec));
if index == 1; pindex = 1;
elseif index == length(ind_vec); pindex = length(ind_vec) - 1;
else
[~,b] = max(abs(ind-ind_vec(index-1:index+1)));
if b == 1; pindex = index;
elseif b == 3; pindex = index - 1;
end
end

% normalized distance from index that is less than particle position
delta = (ind-ind_vec(pindex))/(ind_vec(pindex+1)-ind_vec(pindex));

% for i = 2:length(ind_vec)
%     index = find(ind >= ind_vec(i-1) & ind <= ind_vec(i));
% end
% 
% delta = ind_vec(index-1) + (ind-ind_vec(index-1))/(ind_vec(index)-ind_vec(index-1));
% 
% pindex = index - 1;

end
