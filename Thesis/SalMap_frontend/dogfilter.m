function [ dog ] = dogfilter( N, sigmas, ampls, range )
%DOGFILTER Difference of Gaussians filter
%   DOG = DOGFILTER(N) creates a Difference of Gaussians filter with N
%   samples. N must be a scalar positve integer.
% 
%   DOG = DOGFILTER(N, SIGMAS) allows you to choose the standard deviations
%   of the Gaussians (defaulr t [1/20 1/12]).
% 
%   DOG = DOGFILTER(N, SIGMAS, AMPLS) weights for each Gaussian (default
%   [1 1]).
% 
%   DOG = DOGFILTER(N, SIGMAS, AMPLS, RANGE) defines the filter on the
%   interval [0, RANGE] (default 1).


if nargin < 4
    range = 1;
    if nargin < 3
        ampls = [1 1];
            if nargin < 2
                sigmas = [1/5 1/20];
            end
    end
end

if numel(N)~= 1 || floor(N)~=N || N<=1
    error('"N" must be an integer greater than 1.');
end

if numel(sigmas)~= 2 || ~isnumeric(sigmas)
    error('"sigmas" must be a two element vector of numerics.');
end

if numel(ampls)~= 2 || ~isnumeric(ampls)
    error('"ampls" must be a two element vector of numerics.');
end

if ampls(1)<=0 || ampls(2)<=0
    error('Elements in "ampls" must be positive.');
end

sigma1 = sigmas(1);
sigma2 = sigmas(2);

if sigma1 == sigma2
    error('Elements in "sigmas" must not be equal.');
end

if sigma1 < sigma2 % swap
    sigma1 = sigma1+sigma2;
    sigma2 = sigma1-sigma2;
    sigma1 = sigma1-sigma2;
    ampls = [ampls(2) ampls(1)];
end

% maxsigma = max(sigma1, sigma2);
% maxsigma = 8*maxsigma;
% sigma1 = sigma1/maxsigma; sigma2 = sigma2/maxsigma;

% n = (0:N-1)/(N-1);
% x2 = (n-.5).^2;


% m = mod(N,2);
% n = (0:(N-1)/2)/(N-1);
n = 0:1/(N-1):1;
% n = maxsigma*n;
n = (range*(n-.5)).^2;

% keep the half to achieve symmetric filter(due to arithmetic instability)
% e.g. (1/3-.5)^2 ~= (2/3-.5)^2
g1 = exp(-n/(2*sigma1^2));
% g1 = [g1 g1(end-m:-1:1)];
g1 = g1/sum(g1);
g2 = exp(-n/(2*sigma2^2));
% g2 = [g2 g2(end-m:-1:1)];
g2 = g2/sum(g2);

dog = ampls(2)*g2 - ampls(1)*g1;

% make it symmetric, due to arithmetic errors.
dog = .5*(dog+dog(end:-1:1));

end

