function [ s, t ] = forwardMasking( taskDur )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fs = 16000;
cf = 800;

if nargin < 1
    taskDur = fs*(15 + 15*rand(1));
end

taskDur = taskDur/fs;
spt = 2;
t0 = 1;
targetsNum = floor((taskDur-t0)/spt);
ampl = 1/5;

t = spt*((0:targetsNum-1) + .8*rand(1, targetsNum)) + t0;

twoTones = 1 + round(.7*targetsNum*rand(1));    % number of close spaced tones pairs

r = [ones(twoTones,1); zeros(targetsNum-twoTones,1)];
perm = randperm(targetsNum);
r = r(perm);

gapsDur = .005+.015*rand(twoTones, 1);        % see again the durations
longDur = .3+.3*rand(targetsNum, 1);
shortDur = .015 + .055*rand(twoTones, 1);

if t(end)+longDur(end)+r(end)*shortDur(end) > taskDur
    t(end) = t(end) - longDur(end) - shortDur(end) - 2/fs;
end

s = zeros(round(taskDur*fs), 1);

tfinal = zeros(1, targetsNum+twoTones);
k = 1;
for i = 1:targetsNum
    j = floor(t(i)*fs+1):floor((t(i)+longDur(i))*fs);
    s(j) = modul(sin(2*pi*cf*j/fs));
    tfinal(k+i-1) = t(i);
    
    if r(i)
        j = floor(t(i)*fs+1):floor((t(i)+shortDur(k))*fs);
%         s(j+floor((longDur(i)+gapsDur(k))*fs+1)) = modul(sin(2*pi*cf*j/fs));
        s(j+floor((longDur(i)+gapsDur(k))*fs+1)) = sin(2*pi*cf*j/fs);
        tfinal(k+i) = t(i)+gapsDur(k);
        k = k+1;
    end
end

s = s/max(s);
t = tfinal;

% wavplay(s, fs);


end

