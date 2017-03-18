function [ avgs ] = calcavgs( stat, weights)
%CALCAVGS calculate averages.
%   AVGS = CALCAVGS(STAT,WEIGHTS) calculates weighted average of elements
%   in vector STAT using vector of weights WEIGTHS. If STAT is a matrix, then
%   CALCAVGS works along the columns of STAT and returns a row vector AVGS
%   with averages of columns.


if numel(stat) == length(stat)
    stat = stat(:);
end

if nargin < 2
    avgs = mean(stat);
    return
end


if length(weights) ~= size(stat,1)
    error('"weights" must have the same length as "stat" columns.');
end

avgs = (weights(:)'/sum(weights))*stat;

end

