function [ out ] = meanfilt1( x, n )
%MEANFILT1 Mean filtering
%   OUT = MEANFILT1(X,N) applies mean filtering on the first
%   non-singleton dimension of X. N is the window length in samples to
%   apply the filtering (default 3).

if nargin < 2
    n = 3;
end

if n<=0 || floor(n)~=n
    error('n must be a positive integer.');
end

out = filter(ones(n,1)/n, 1, x);

end

