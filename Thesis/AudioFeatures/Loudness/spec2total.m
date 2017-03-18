function [ loudness ] = spec2total( specLoudness, F )
%   from specific loudness estimate total loudness.

if nargin < 2
    F = .15;
end

m = max(specLoudness);

loudness = sum(specLoudness);
loudness = F*loudness + (1-F)*m;

end

