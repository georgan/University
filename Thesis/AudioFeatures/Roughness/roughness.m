function [ R ] = roughness( x, fs, N, Nolap, Nfft, varargin )
%ROUGHNESS Computes sound roughness
%   R = ROUGHNESS(X, FS) estimates the roughness R of signal X in short time
%   windows of length 200 msec., with overlap 190 msec. FS is the sampling
%   frequency of signal X. R is a vector with the estimated roughness for
%   each time window.
% 
%   R = ROUGHNESS(X, FS, N) specifies the short time window length N, in
%   samples.
% 
%   R = ROUGHNESS(X, FS, N, NOLAP) specifies the overlap between succesive
%   windows NOLAP, in samples.
% 
%   R = ROUGHNESS(X, FS, N, NOLAP, NFFT) specifies the number of points used
%   to compute the DFT of X, that is required for the estimation of
%   roughness R. Default value is 2^(ceil(log2(N))+1).
% 
%   R = ROUGHNESS(...,'Param1',Value1, 'Param2',Value2, ...) allows control
%   of some parameters of the procedure in parameters name/value pairs.
%   Parameters are:
%       'method' - Method used to compute the roughness. Choises are:
%           'vassilakis' - use Vassilakis's method (default).
%           'sethares' - use Sethares's method which is simpler. The output
%            of this method is highly correlated to the energy of the signal.
% 
%       'amplthresh' - threshold of amplitude in order to consider a peak
%       at the spectrum at the estimation of roughness. It must be in the
%       range [0, 1) and shows the percentage of the highest peak in the
%       spectrum (default 0.001).
% 
%       'freqlow' - minimum difference in Hz between a pair of peaks, in
%       order to consider the pair at the estimation of roughness (default
%       10 Hz).
%       Note: it is required high resolution (FS/Nfft) at the
%       spectrum in order to achieve low differences.
% 
%       'frequp' - maximum difference in Hz between a pair of peaks, in
%       order to consider the pair at the estimation of roughness (default
%       200 Hz)
% 
%   Example:
%       [s, fs] = wavread('noiseburst_example.wav');
%       r = roughness(s,fs);
% 
%       figure;
%       t = linspace(0, length(s)/fs, length(r));
%       plot(t, r); xlim([0 t(end)]);
%       xlabel('Time (sec)'); ylabel('Roughness');
%       movingLine(gcf,s,fs);
% 
%   See also pair_roughness




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
    warning('Number of points of FFT is less than signal''s length.');
end


numargin = length(varargin);

if mod(numargin,2)
    error('Property Name-Value input arguments must come in pairs.');
end


amplthresh = .001; % of the maximum value in spec
freqlowthresh = 10; % Hz
frequpthresh = 200;
method = 'vassilakis';


for i = 1:2:numargin
    property = varargin{i};
    if ~ischar(property)
        error('Property names must be strings.');
    end
    
    value = varargin{i+1};
    switch property
        case 'freqlow'
            freqlowthresh = value;
        case 'frequp'
            frequpthresh = value;
        case 'amplthresh'
            amplthresh = value;
        case 'method'
            method = value;
        otherwise
            error(['Invalid property name: ' property]);
    end
end


%%%%%%%%%%%%%%%%% DO THE JOB %%%%%%%%%%%%%%%%%%%%%


si = preprocess(x, N, Nolap, 'hann');

Xf = fft(si, Nfft);
Xf = abs(Xf);

if isreal(x)
    Xf = Xf(1:Nfft/2,:);
end

R = frameroughness(Xf,fs,method,amplthresh,freqlowthresh,frequpthresh);


end

