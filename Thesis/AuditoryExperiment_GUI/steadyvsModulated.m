function [ s, t ] = steadyvsModulated( taskDur, targets )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% taskdur is in samples. it will change...
% targets = 0 -> modulated targets
% targets = 1 -> steady targets
fs = 16000;
if nargin < 1
    taskDur = floor(fs*(10 + 10*rand(1)));
    targets = 0;
elseif nargin == 1
    if taskDur <= 1
        targets = taskDur;
        taskDur = floor(fs*(10 + 10*rand(1)));
    else
        targets = 0;
    end
end

taskDur = taskDur/fs;
spt = 2;    % seconds per target
dps = 3;    % distractors per second
t0 = 1;     % targets appear after t0
ampl = 1/5;
Freq = 5;  % modulation frequency, 8 Hz is used by Cusack and Carlyon
tonesDur = .2;  % 250 ms is used by Cusack and Carlyon

targetsNum = floor((taskDur-t0)/spt);
distractorsNum = ceil(taskDur*dps);

tTargets = spt*((0:targetsNum-1) + .8*rand(1, targetsNum)) + t0;

tDistractors = round(10*(taskDur*rand(distractorsNum, 1))-1)/10;
tDistractors(tDistractors < 0) = 0;
tDistractors(tDistractors+tonesDur > taskDur) = taskDur - tonesDur;
tDistractors = sort(tDistractors);
[allt ind] = sort([tTargets tDistractors']);

% x = rand(targetsNum+distractorsNum,1);
% f = 262+(4192-262)*lognpdf(x,0,1);

f = random('logn', 3/2, 1/4, [targetsNum+distractorsNum, 1]);
lowfreq = 262; upfreq = 4192;
f = lowfreq + (upfreq-lowfreq)/10*f;

% f(targetsNum+1:end) = adjustFreq(f(targetsNum+1:end), tDistractors, tonesDur);
f = adjustFreq(f, allt, tonesDur);
% display(num2str([f allt']));

tTargets = allt(ind >=1 & ind <= targetsNum);
tDistractors = allt(ind > targetsNum)';
f = [f(ind >=1 & ind <= targetsNum); f(ind > targetsNum)];

s = zeros(round(taskDur*fs), 1);

if targets
    tmodulated = tDistractors;
    tsteady = tTargets;
    steadyNum = targetsNum;
    modulatedNum = distractorsNum;
    fsteady = f(1:targetsNum);
    fmodulated = f(targetsNum+1:end);
else
    tmodulated = tTargets;
    tsteady = tDistractors;
    steadyNum = distractorsNum;
    modulatedNum = targetsNum;
    fsteady = f(targetsNum+1:end);
    fmodulated = f(1:targetsNum);    
end


for i = 1:modulatedNum
    j = floor(tmodulated(i)*fs+1):floor((tmodulated(i)+tonesDur)*fs);
    a = sin(2*pi*fmodulated(i)*j/fs)';
    s(j) = s(j) + sin(2*pi*Freq*a);
end


for i = 1:steadyNum
    j = floor(tsteady(i)*fs+1):floor((tsteady(i)+tonesDur)*fs);
    s(j) = s(j) + sin(2*pi*fsteady(i)*j/fs)';
end

s = s/max(s);
t = tTargets;
% figure, plot((1:length(s))/fs, s);

% wavplay(s, fs)

end

