function si = preprocessMFCC( signal, params )
%PREPROCESSMFCC Preprocessing stage of MFCC
% Input:
%   signal: signal to preprocess
%   params: parameters for the feature exteaction stage which is returned
%   by confstruct function.

signal = mean(signal, 2); % mean over multiple channels

if params.zmeansource
    signal = signal - mean(signal);
end

sp = signal - params.proemph*[signal(1); signal(1:end-1)]; % use filter

window = params.T*params.fs;
windowOlap = params.Toverlap*params.fs;
si = buffer(sp, window, windowOlap);

hammingFilter = hamming(window)*ones(1,size(si,2));
si = si.*hammingFilter;


end

