function gistvec = gist(map, n, m, fun)
%GIST Compute gist vector
% GISTVEC = GIST(MAP,N,M,FUN) computes gist vector of 2D map MAP using NxM grid
% (rows-by-columns). FUN is the function that is applied to each region
% that it is defined by the grid. FUN is any function that gets one
% input argument which is a vector, and can be executed by MATLAB's
% function feval. 
% 
% See also feval.


if length(n)>1 || length(m)>1 || ~isnumeric(n) || ~isnumeric(m) ||...
        any(floor([n m])~=[n m]) || n<=0 || m<=0
    error('"n", "m" must be positive integers.');
end


rowblock = round((0:1/n:1)*size(map, 1));
colblock = round((0:1/m:1)*size(map, 2));

gistvec = zeros(n*m, 1);
for i = 1:m
    for j = 1:n
        block = map(rowblock(j)+1:rowblock(j+1), colblock(i)+1:colblock(i+1));
        gistvec((i-1)*n+j) = feval(fun, block(:));
    end
end

end

