function [ Energy ] = extractEnergy( spfft, params, filterBank )
%EXTRACTENERGY computes energy
%   ENERGY = EXTRACTENERGY(SPFFT,PARAMS,FILTERBANK) computes the energy
%   of a signal in each band of a filterbank specified by FILTERBANK and
%   returns the result on ENERGY. SPFFT is the spectrum of the signal and
%   PARAMS is a structure as it is returned by confstruct. SPFFT can also be a
%   matrix where each column contains the spectrum of a signal. FILTERBANK
%   is a matrix, where each row contains the frequency response
%   of a filter.


if params.usepower
    Energy = filterBank.^2*(abs(spfft(1:params.Nfft/2+1,:)).^2).^2;
else
    Energy = filterBank.^2*(abs(spfft(1:params.Nfft/2+1,:))).^2;
end

end

