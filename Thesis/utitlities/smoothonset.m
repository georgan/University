function [ smooths ] = smoothonset( s, n, side )
%SMOOTHONSET Smooth onset-offset
%   SMOOTHS = SMOOTHONSET(S) weights the beginning and ending of signal S
%   by a Hanning window of length 10 in order to have smooth onset and
%   offset.
% 
%   SMOOTHS = SMOOTHONSET(S,N) weights by a Hanning window of length 2*N.
% 
%   SMOOTHS = SMOOTHONSET(S,N,SIDE) allows the user which side of the
%   signal S to smooth. Choises are:
%       'both' - smooths onset and offset (default).
%       'front' - smooths onset only.
%       'back' - smooths offset only.

l = length(s);

if nargin < 3
    side = 'both';
    if nargin < 2
        n = min(5,floor(l/2));
    end
end

if n > l/2
    warning('n greater than half of signal''s lengths.');
    n = floor(l/2);
end

whan = hann(2*n);

mask = ones(size(s));


if strcmp(side,'both')
    mask(1:n) = whan(1:n);
    mask(end-n+1:end) = whan(n+1:2*n);
elseif strcmp(side,'front')
    mask(1:n) = whan(1:n);
elseif strcmp(side,'back')
    mask(end-n+1:end) = whan(n+1:2*n);
else
    fprintf(1,'Not accepted smoothing side. No smoothing applied.\n');
end

smooths = mask.*s;


end

