function [ nrg ] = stnrg( x, fs, N, Nolap )
%STNRG Short Time Energy
%   NRG = STNRG(X,FS) computes the short time energy NRG of signal X with
%   sampling frequency FS, in time windows of 30 msec with 20 msec overlap
%   between succesive windows.
% 
%   NRG = STNRG(X, FS, N) specifies the short time window length N, in
%   samples.
% 
%   NRG = STNRG(X, FS, N, NOLAP) specifies the overlap between succesive
%   windows NOLAP, in samples.


if nargin < 4
    if nargin < 3
        N = .03*fs;
    end
    Nolap = max(N - .01*fs,0);
end


si = preprocess(x, N, Nolap, 'hann');

nrg = sum(si.^2);

end

