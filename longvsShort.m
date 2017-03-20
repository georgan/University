function [s, t] = longvsShort( taskDur, targets )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% targets = 0 -> long targets
% targets = 1 -> short targets
fs = 16000; 
if nargin < 1
    taskDur = floor(fs*(10 + 10*rand(1)));
    targets = 0;
elseif nargin == 1,
    if taskDur == 0 || taskDur == 1
        targets = taskDur;
        taskDur = floor(fs*(10 + 10*rand(1)));
    else
        targets = 0;
    end
end

taskDur = taskDur/fs;
spt = 2;    % seconds per target
dps = 2;   % distractors per second
t0 = 1;     % targets appear after t0
ampl = 1/5;

targetsNum = floor((taskDur-t0)/spt);
distractorsNum = ceil(taskDur*dps);
shortDur = .1; longDur = .3;

tTargets = spt*((0:targetsNum-1) + .8*rand(1, targetsNum)) + t0;

% tDistractors = taskDur*rand(distractorsNum, 1);
tDistractors = round(10*(taskDur*rand(distractorsNum, 1))-1)/10;
tDistractors(tDistractors < 0) = 0;
tDistractors = sort(tDistractors);
[allt ind] = sort([tTargets tDistractors']);

% x = 12*rand(targetsNum+distractorsNum,1);
% f = 262+(4192-262)*lognpdf(x,0,1);        % does not give logarithmic distribution

f = random('logn', 3/2, 1/4, [targetsNum+distractorsNum, 1]);
lowfreq = 262; upfreq = 4192;
f = lowfreq + (upfreq-lowfreq)/10*f;

% f(targetsNum+1:end) = adjustFreq(f(targetsNum+1:end), tDistractors, longDur);
f = adjustFreq(f, allt, longDur);
% display(num2str([f allt']));

tTargets = allt(ind >=1 & ind <= targetsNum);
tDistractors = allt(ind > targetsNum)';
f = [f(ind >=1 & ind <= targetsNum); f(ind > targetsNum)];

% lowfreq = 262;
% upfreq = 4192;
% 
% m = (lowfreq+upfreq)/2;
% % m = 1000;
% v = (upfreq - lowfreq)/6;
% mu = log((m^2)/sqrt(v+m^2));  mu = 3/2; sigma = 1/4;
% sigma = sqrt(log(v/(m^2)+1));
% 
% % mu = 5;
% % sigma = 1.3;
% % f = lognrnd(mu, sigma, targetsNum+distractorsNum, 1);
% % figure, plot(f)

s = zeros(round(taskDur*fs), 1);

if targets
    distractorsDur = longDur;
    targetsDur = shortDur;
else
    distractorsDur = shortDur;
    targetsDur = longDur;
end

tDistractors(tDistractors+distractorsDur > taskDur) = taskDur - distractorsDur - 2/fs;

for i = 1:targetsNum
    v = (floor(tTargets(i)*fs)+1):(floor(tTargets(i)*fs)+floor(targetsDur*fs));
    s(v) = s(v) + modul(sin(2*pi*f(i)*(1:floor(targetsDur*fs))/fs))';
end

for i = 1:distractorsNum
    v = (floor(tDistractors(i)*fs)+1):(floor(tDistractors(i)*fs)+floor(distractorsDur*fs));
    s(v) = s(v) + modul(sin(2*pi*f(i+targetsNum)*(1:floor(distractorsDur*fs))/fs))';
end

s = s/max(s);
t = tTargets;
% display(sort(tDistractors));

% wavplay(s, fs);

end

