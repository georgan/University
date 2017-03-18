function [ zcr ] = zeroCrossingRate( x,fs, N, Nolap )
%ZeroCrossingRate
%   ZCR = ZEROCROSSINGRATE(X,FS) computes the zero-crossing-rate ZCR of signal X with
%   sampling frequency FS, in time windows of 30 msec with 20 msec overlap
%   between succesive windows.
% 
%   ZCR = ZEROCROSSINGRATE(X, FS, N) specifies the short time window length N, in
%   samples.
% 
%   ZCR = ZEROCROSSINGRATE(X, FS, N, NOLAP) specifies the overlap between succesive
%   windows NOLAP, in samples.


if nargin < 4
    if nargin < 3
        N = .2*fs;
    end
    Nolap = max(N - .01*fs,0);
end
if size(x, 1) == 1;
    x = x';
    flag = 1;
else
    flag = 0;
end

wname = 'hamming';


si = preprocess(x,N,Nolap,wname);


z = sign(si(2:end,:))-sign(si(1:end-1,:));

z = abs(z)/2;

zcr = mean(z);

if ~flag
    zcr = zcr';
end


end

