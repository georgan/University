function output = modul( signal, modulfun, trans )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3, trans = max(min(ceil(.04*length(signal)), 60), 16); end
if nargin < 2, modulfun = 'gauss'; end
if nargin < 1 , error('Not enough input arguments.'); end

if trans > length(signal)
    warning('Transition length is greater than signal length');
    trans = length(signal);
end

if strcmp(modulfun, 'gauss')
    g = exp(-((1:trans)/trans - .5).^2/(2*(1/7)^2));
elseif strcmp(modulfun, 'hamming')
    g = hamming(trans)';
elseif strcmp(modulfun, 'ramp')
    g(1:trans/2) = (1:trans/2)/(trans/2);
    g(trans/2+1:trans) = g(trans/2:-1:1);
else
    error('Unknown modulation function.');
end

w = ones(size(signal));
l = length(g);
w(1:floor(l/2)) = g(1:floor(l/2)); w(end-floor(l/2)+1:end) = g(end-floor(l/2)+1:end);

output = w.*signal;

end

