function [ L ] = estimloudness( psd, barklims, eqlcon, phonlevels )
%ESTIMLOUDNESS Estimates loudness
%   L = ESTIMLOUDNESS(PSD, BARKLIMS, EQLCON, PHONLEVELS)
%   psd: power spectral density
%   barklims: bark scale limits in samples


nrg = bandnrg(psd,barklims);
s = spread(1:length(barklims)-1);
nrg = s*nrg;
dbspl = 10*log10(nrg+eps);
% dbspl(dbspl < 0) = 0;
% phon = dbspl;

phon = db2phon(dbspl, eqlcon, phonlevels);

sone = phon2sone(phon);
L = sum(sone);
% L = spec2total(sone);


end

