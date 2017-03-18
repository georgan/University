function [ out ] = scale( x )
%SCALE Features scaling
%   OUT = SCALE(X) scales vector X to have values on [0,1] interval. X can
%   be a matrix, where the scaling is applied on each row.

if size(x,2)==1
    x = x';
    flag = 1;
else
    flag = 0;
end

out = bsxfun(@minus, x, min(x,[],2));
out = bsxfun(@rdivide, out, max(out,[],2));

if flag
    out = out';
end

end

