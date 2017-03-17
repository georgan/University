function [ displ_x, displ_y ] = displ( d_x, d_y )
%DISPL Calculates 
%   [displ_x, displ_y] = displ(d_x, d_y) takes as input two vector fields,
%   d_x and d_y, and returns a 1-by-2 vector [displ_x, displ_y] that is the
%   mean value of those d_x, d_y, respectively, whose energy is greater
%   than the eighty per cent of the maximum energy of a vector that appears
%   in thefield.

d = d_x.^2 + d_y.^2;            %calculate energy
thres = .8*max(d(:));           %threshold
k = find(d > thres);            %vectors with energy greater than threshold
displ_x = round(mean(d_x(k)));  %calculate mean value
displ_y = round(mean(d_y(k)));

end

