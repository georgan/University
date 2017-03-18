function [ nrg ] = bandnrg( psd, bandlims )
%BANDNRG Band energy of signal
%   NRG = BANDNRG(PSD,BANDLIMS) computes the energy NRG of a signal in each
%   frequency band using the power spectral density PSD and the frequency
%   band limits BANDLIMS. PSD can be a vector or a matrix. If PSD is a
%   matrix then each column contains the power spectral density of a
%   signal. BANDLIMS is vector of band boundaries in samples. The succesive
%   elements in BANDLIMS define the boundaries of the bands.

if size(psd,1) == 1
    flag = 1;
    psd = psd';
else
    flag = 0;
end

l = length(bandlims);
nrg = zeros(l-1, size(psd,2));
for i = 1:l-1
    nrg(i,:) = sum(psd(bandlims(i)+1:bandlims(i+1),:));
end

if flag
    nrg = nrg';
end

end

