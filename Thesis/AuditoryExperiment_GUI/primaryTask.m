function [s TonesNum] = primaryTask( dur )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fs = 16000;
cfh = 500;
cfl = 200;
TonesDur = dur(1);
GapDur = dur(2);

trans = .03;    % transition from 0 to wave amplitude
flag = 1;

ldown = 20 + fix((25-20)*rand(1));
lup = 40 + fix((45-40)*rand(1));
hdown = 20 + fix((25-20)*rand(1));
hup = 40 + fix((45-40)*rand(1));

lnum = ldown+fix((lup-ldown)*rand(1));
hnum = hdown+fix((hup-hdown)*rand(1));

ampl = 1/5;
sh = sin(2*pi*cfh*(1:TonesDur*fs)/fs);
sl = sin(2*pi*cfl*(1:TonesDur*fs)/fs);


if flag
    sh = modul(sh, 'gauss', ceil(trans*fs));
    sl = modul(sl, 'gauss', ceil(trans*fs));
end

sl = sl*sqrt((1+cfh^2)/(1+cfl^2));
% sh = sh*sqrt((1+cfh^2)/(1+cfl^2));
sh = [sh zeros(1, ceil(GapDur*fs))];
sl = [sl zeros(1, ceil(GapDur*fs))];

% r = round(rand(30, 1));
perm = randperm(lnum+hnum);
r = [zeros(lnum,1); ones(hnum,1)];
r = r(perm);
s = (1-r)*sl + r*sh;

s = s'; s = 1*s(:);
TonesNum = [lnum hnum];

end

