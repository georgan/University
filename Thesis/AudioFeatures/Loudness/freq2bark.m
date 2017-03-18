function [ z ] = freq2bark( freq )
%FREQ2BARK Linear to Bark scale
%   Z = FREQ2BARK(FREQ) computes the frequency Z in Bark scale from the
%   frequency FREQ in Hz. FREQ is an array.

if nargin < 1
    error('Not enough input arguments.');
end

if ~isnumeric(freq)
    error('freq must be numeric.');
end

freq = double(freq);
z = 13*atan(.00076*freq) + 3.5*(atan(freq/7500)).^2;

end

