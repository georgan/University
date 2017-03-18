function [ L ] = loudness( x, fs, N, Nolap, Nfft )
%LOUDNESS Compute sound loudness
%   L = LOUDNESS(X, FS) estimates the loudness L of signal X in short time
%   windows of length 200 msec., with 190 msec overlap. FS is the sampling
%   frequency of signal X. L is a vector with the estimated loudness for
%   each time window.
% 
%   L = LOUDNESS(X, FS, N) specifies the short time window length N, in
%   samples.
% 
%   L = LOUDNESS(X, FS, N, NOLAP) specifies the overlap between succesive
%   windows NOLAP, in samples.
% 
%   L = LOUDNESS(X, FS, N, NOLAP, NFFT) specifies the number of points used
%   to compute the DFT of X, that is required for the estimation of
%   loudness L. Default value is 2^(ceil(log2(N))+1).


if nargin < 5
    if nargin < 4
        if nargin < 3
            N = .2*fs;
        end
        Nolap = max(N - .01*fs,0);
    end
    Nfft = 2^(nextpow2(N)+1);
end

if Nfft < N
    warning('Number of points of FFT is less than signal''s length');
end

si = preprocess(x, N, Nolap, 'hann');

Xf = fft(si, Nfft);
Xf = abs(Xf);
Xf = calibrate(Xf);

psd = Xf.^2/Nfft;

if isreal(x)
    psd = 2*psd(1:Nfft/2,:);
end

load 'BarkScaleLims.mat';
load EqualLoudnessContours.mat;

barklims = ceil(barklims/fs*Nfft);

L = estimloudness(psd,barklims,eqlcon,phonlevels);


end

