function [ out ] = standardize( x )
%STANDARDIZE Standardize features
%   OUT = STANDARDIZE(X) makes data of vector X to have zero mean and unit
%   standard deviation. If X is a matrix, STANDARDIZE operates along the
%   rows of X.

if size(x,2)==1
    x = x';
    flag = 1;
else
    flag = 0;
end

out = bsxfun(@minus, x, mean(x,2));
out = bsxfun(@rdivide, out, std(out,0,2));

if flag
    out = out';
end

end

