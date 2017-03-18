function [ IM2 ] = opening( IM, SE )
%OPENING Opening morphological operator
%   IM2 = OPENING(IM,SE) applies opening on image IM using structuring
%   element SE, to produce image IM2. IM can be also a 1D signal.
% 
% See also imerode, imdilate.

IM2 = IM;
IM2 = imerode(IM2, SE);
IM2 = imdilate(IM2, SE);

end

