function [MFCC, Energy] = extractMFCC( x, params, filterBank)
%extractFeatures extracts MFCC features and energies in short time
%framework of signal x.
% Input:
%   x: sound signal
%   params: structure which is reurned by confstruct
%   filterbank: (Mel) filterbank used to compute the features.
% 
%   Example:
%       [s, fs] = wavread('amplitude_modulation_example.wav');
%       params = confstruct;
%       fBank = extractFilterBank(params);
%       mfcc = extractMFCC(s,params,fBank);


sp = preprocessMFCC(x,params);

spfft = fft(sp, params.Nfft);

Energy = extractEnergy(spfft, params, filterBank);

epsln = .00000000001;
logE = log(Energy+epsln);
MFCC = dct(logE);
MFCC = MFCC(1:params.Nc, :);

delta = [];
if params.vel
    delta = extractDerivs(MFCC, params, 'delta');
    MFCC = [MFCC; delta];
end


if params.acc
    if isempty(delta)
        delta = extractDerivs(MFCC, params, 'delta');
    end
    
    acc = extractDerivs(delta, params, 'alpha');
    MFCC = [MFCC; acc];
end


end
