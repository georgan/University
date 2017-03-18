function [ S ] = spread( ind )
%SPREAD Spread function
%   S = SPREAD(IND) cumputes spreading function to model masking
%   across frequency bands in Bark scale. IND is a vector of indices
%   that correspond to frequency bands. S is a DxD matrix, where D is the
%   length of IND. If SPL is a Dx1 vector with sound pressure level in db
%   for each frequency band, then in order to model the masking between the
%   frequency bands, compute S*SPL.
% 
%   Example: model masking between first 10 bands: s = spread(1:10);

%   M. R. Schroeder, B. S. Atal, and J. L. Hall, "Optimizing digital speech coders by
%   exploiting masking properties of the human ear," J. Acoust. Soc. Am., vol. 66, no. 6,
%   pp. 1647–1652, 1979.

if nargin < 1
    error('Not enough input arguments.');
end

if any(floor(ind)~=ind) || any(ind<=0)
    error('Elements of ind must be positive integers.');
end

S = zeros(length(ind));
for i = ind
    for j = ind
    S(i,j) = 10.^((15.81+7.5*((i-j)+0.474)-17.5*...
        sqrt(1+(i-j+0.474).^2))/10);
    end
end

end

