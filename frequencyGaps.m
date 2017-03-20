function [ s, t ] = frequencyGaps( taskDur )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

fs = 16000;

if nargin < 1
    taskDur = floor(fs*(10+10*rand(1)));
end

taskDur = taskDur/fs;
n = randn(round(taskDur*fs),1);
n = n/max(n);
nrg = sum(n.^2);

t0 = 1;     % targets appear after t0(in sec)
spt = 2;    % seconds per target
% gapsNum = 5+fix(5*rand(1));
gapsNum = floor((taskDur-t0)/spt);
gapdur = .1;
ampl = 1/5;

% spt = taskDur/gapsNum;

t = spt*((0:gapsNum-1) + .8*rand(1, gapsNum)) + t0;
if t(end) > taskDur
    t(end) = taskDur-gapdur;
end

% t = round(10*(max(n)-1)*rand(gapsNum,1))/10;
f = 400 + fix(1600*rand(gapsNum,1));
bw = 800 + fix(1600*rand(gapsNum,1));  % 1600

for i = 1:gapsNum
    v = floor(t(i)*fs+1):floor((t(i)+gapdur)*fs);
    m = max(n(v));
    nfft = fft(n(v));
    w = ones(size(nfft));
    l = length(nfft);
    r = l/fs;
    w = makefilter(l, fs, f(i), bw(i), 'gauss'); %figure, plot(w);
%     w(floor(f(i)*r+1):floor((f(i)+bw(i))*r)) = 0;
%     w(l - (floor(f(i)*r+1):floor((f(i)+bw(i))*r))) = 0;
    nfft = nfft.*w;
%     nfft(end/2+1:end) = nfft(end/2:-1:1);
    nn = ifft(nfft);
    n(v) = real(nn);
    n(v) = n(v)*m/max(n(v));
end

% n = n*nrg/sum(n.^2);
s = n;


% wavplay(s/2, fs);

end

