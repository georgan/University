function [ pairs ] = allpairs( x, y )
%ALLPAIRS Pairs between vectors
%   PAIRS = ALLPAIRS(X) returns all the distinct couples of elements in X.
%   X must be a vector with N elemtns. PAIRS is a 2 x N(N-1)/2 matrix where
%   each row contains a pairs of elements in X.
% 
%   PAIRS = ALLPAIRS(X,Y) returns all pairs between elements in vectors X
%   and Y.
% 
%   Example:
%       p = allpairs([1 2], [5 6]); returns [1 5;1 6; 2 5; 2 6]


if nargin < 1
    error('Not enough input arguments.');
elseif nargin == 1
    l = length(x);
% % %     pairs = zeros(l*(l-1)/2, 2);
    ind = (1:l)';
% % %     ind = ind*ones(1,l);
    ind = repmat(ind, 1, l);
    
% % %     x = x(:)*ones(1,l);
    x = repmat(x(:), 1, l);
    a = ind > ind';
    z = x';
    pairs = [z(a) x(a)];
% % %     pairs(:,1) = z(a);
% % %     pairs(:,2) = x(a);
    
% % %     [a, b] = meshgrid(x);
% % %     ind = a<b;
% % % %     pairs = [a(ind) b(ind)];
% % %     pairs(:,1) = a(ind);
% % %     pairs(:,2) = b(ind);
% %     pairs = ind;
    
else
    [X, Y] = meshgrid(x,y);
    pairs = [X(:) Y(:)];
end

end

