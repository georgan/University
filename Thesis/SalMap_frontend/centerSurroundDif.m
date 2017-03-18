function [ cspyr ] = centerSurroundDif( pyr, center, scalesDif )
%CENTERSURROUNDDIF Center-Surround Differences
%   CSPYR = CENTERSURROUNDDIF(PYR, CENTER, SCALESDIF) computes
%   center-surround differences of scales on pyramid PYR and the result is
%   stored on CSPYR. PYR can be a Dx1 or 1xD cell array or a DxN matrix,
%   where D is the number of scales. If PYR is a cell array, the
%   differences are taken between entries of the cell. If PYR is a matrix,
%   each row of PYR corresponds to one scale, and differences are taken
%   between rows. CSPYR is of the same data type as PYR. Use the matrix
%   version when you deal with one dimensional signals, and the cell array
%   version for signals with more than one dimensions (e.g. images).
% 
%   CENTER and SCALESDIF are vectors of scale indices in PYR that specify
%   center scales and scale differences, respectively.


if nargin < 3
    error('Not enough input arguments.');
end

if nargin > 3
    error('Too many input arguments.');
end

if isempty(center) || isempty(scalesDif)
    error('At least one center and one surround scales are required.');
end

if any(floor(center)~=center) || any(floor(scalesDif)~=scalesDif)
    error('center and scalesDif must have integer elements.');
end

if iscell(pyr)
    cspyr = cell(length(center)*length(scalesDif), 1);
    lpyr = length(pyr);
    df = 'a = pyr{center(i)} - pyr{center(i)+scalesDif(j)};';
    asign = 'cspyr{(i-1)*length(scalesDif)+j} = a;';
else
    cspyr = zeros(length(center)*length(scalesDif), size(pyr,2));
    lpyr = size(pyr,1);
    df = 'a = pyr(center(i),:) - pyr(center(i)+scalesDif(j),:);';
    asign = 'cspyr((i-1)*length(scalesDif)+j,:) = a;';
end

if min(center)+min(scalesDif) > lpyr
    error(sprintf(['The minimum surround scale is larger than the number of scales.\n'...
        'No scale differences taken. Use smaller center or scalesDif parameters.']));
end

center = unique(center);
scalesDif = unique(scalesDif);

n = 0;
for i = 1:length(center)
    for j = 1:length(scalesDif)
        if center(i)+scalesDif(j) <= lpyr
            n = n+1;
%             a = pyr{center(i)} - pyr{center(i)+scalesDif(j)};
            eval(df);
            a = a.*(a > 0);
%             cspyr{(i-1)*length(scalesDif)+j} = a;
            eval(asign);
        end
        
    end
end

cspyr = cspyr(1:n,:);

end

