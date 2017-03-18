function params = confStruct
%CONFSTRUCT MFCC parameters
%   PARAMS = CONFSTRUCT returns parameters to compute MFCC features in
%   structure PARAMS.

params.proemph = .97;
params.Q = 24;
params.T = .03;
params.Toverlap = .02;
params.Nc = 13;
params.fs = 16000;
params.Nfft = 2^(floor(log2(params.T*params.fs))+2);

params.usepower = false;
params.zmeansource = true;

params.vel = true;
params.velwin = 2;

params.acc = true;
params.accwin = 2;

end

