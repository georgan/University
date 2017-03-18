function [ flux ] = specflux( x, fs )
%SPECFLUX Computes spectral flux
%   FLUX = SPECFLUX(X, FS) estimates the spectral flux FLUX of signal X in short time
%   windows of length 30 msec., with 20 msec overlap. FS is the sampling
%   frequency of signal X. FLUX is a vector with the estimated spectral
%   flux at each time window.
% 
%   FLUX = SPECFLUX(X, FS, N) specifies the short time window length N, in
%   samples.
% 
%   FLUX = SPECFLUX(X, FS, N, NOLAP) specifies the overlap between succesive
%   windows NOLAP, in samples.
% 
%   FLUX = SPECFLUX(X, FS, N, NOLAP, NFFT) specifies the number of points used
%   to compute the DFT of X, that is required for the estimation of
%   flux FLUX. Default value is 2^(ceil(log2(N))+1).


if nargin < 5
    if nargin < 4
        if nargin < 3
            N = .03*fs;
        end
        Nolap = max(N - .01*fs,0);
    end
    Nfft = 2^(nextpow2(N)+1);
end

if Nfft < N
    warning('Number of points of FFT is less than signal''s length');
end


nrgthresh = 10e-8;
amplthresh = .05;

si = preprocess(x,N,Nolap,'hamming');

Xf = fft(si, Nfft);
Xf = abs(Xf);

psd = 2*Xf(1:Nfft/2,:).^2/Nfft;


nrg = sum(psd);
nrgind = ones(Nfft/2,1)*(nrg<nrgthresh);
nrg(nrg<nrgthresh) = 1;

maxampl = max(psd);
amplind = psd < (ones(Nfft/2,1)*maxampl*amplthresh);
psd(amplind) = 0;

psd(nrgind==1) = 0;
psd = psd./(ones(Nfft/2,1)*nrg);


flux = diff(psd,1,2);
flux = sum(flux.^2);
flux = [flux(1) flux];


end

