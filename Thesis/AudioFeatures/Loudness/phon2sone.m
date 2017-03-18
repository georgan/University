function [ sone ] = phon2sone( phon )
%PHON2SONE Converts phon to sone
%   SONE = PHON2SONE(PHON) converts the loudness PHON measured in phons to
%   loudness SONE measured in sones. PHON and SONE are arrays of the same
%   size.


sone = 2.^(phon/10-4);
ind = phon < 40;
sone(ind) = (phon(ind)/40).^2.642;

end

