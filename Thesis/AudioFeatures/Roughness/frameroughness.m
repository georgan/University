function [ R ] = frameroughness( spec, fs, method, amplthresh, freqlowthresh, frequpthresh)

%   spec: spectrum of the signal
%   fs: sampling frequency
%   method: method to compute roughness
%   amplthresh: amplitude threshold to consider peaks
%   freqlowthresh: minimum frequency difference between peaks.
%   frequpthresh: maximum frequency difference between peaks.

if size(spec, 1) == 1
    spec = spec';
end


[Nfft, nframes] = size(spec);

maxspec = max(spec);
maxspec = repmat(maxspec, Nfft, 1);
spec(spec < amplthresh*maxspec) = 0;


vec = (1:Nfft)';
R = zeros(1,nframes);

lm = R;
for i = 1:nframes
    locmax = localextrema(spec(:,i));
    
    lm(i) = sum(double(locmax));
    if sum(double(locmax)) > 1
        ind = vec(locmax > 0);
        F = (ind-1)/Nfft*fs/2;
        M = spec(ind,i);
        
        f = allpairs(F);
        m = allpairs(M);
        
        df = abs(f(:,1)-f(:,2));
        df = (df > freqlowthresh) & (df < frequpthresh);
        f = f(df,:); m = m(df,:);
        
        
        if ~isempty(f)
            r = pair_roughness(m, f, method);
            R(i) = sum(r);
        else
            R(i) = 0;
        end
        
    else
        R(i) = 0;
    end
    
end


end

