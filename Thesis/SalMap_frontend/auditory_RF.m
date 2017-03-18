function out = auditory_RF(sideband, postinh, theta)
%
% Computes and auditory RF model consisting of a Gabor, with or
% without sidebands in frequency direction and a possible post-inhibition.
% the parameters are:
%
% LAT = [Latency Gabor, Latency post-inh]
% BW  = [Bandwidth Gabor, Bandwidth post-inh]
% sideband if 1 sidebands appear
% postinh if 1 a post-inhibition is added
% theta: angle in radians, to rotate the filters.
%
% time in 1 ms steps and frequency in quarter tones!

% Adapted from Kayser's original code. Added input argument "theta" that
% rotates the filters at the desired angle.

% the parameters
if postinh || ~sideband || nargin < 3
    theta = pi/2;
end

LAT = [24,50]/40;
BW = [0.035,0.04];
Freq = 1;
%DUR = 5;
DUR = 5/40;
freq = [1 1];

if sideband
  BW(1) = 0.08;
else
  BW(2) = 0.035;
end

% this is the frequency vector
OCTAVES = round(1.3458*2.^[5:1/8:13]);

% time in 1 ms steps and frequency in quarter tones!
Fax = [0.3:1/32:1.7-0.000001];
Tax = [1:80]/40;
% Fax = [0.3:1/32:1.7-0.000001]; Fax = Fax(1:floor(end/2));
% Tax = [1:20]/20;

% Tax = [1:80];
[T,F] = meshgrid(Tax,Fax);
LAT = LAT;
BW = BW*4;

% the gabor
% env = exp( -( ((T-LAT(1)).^2)/(2*DUR^2) + ((F-1).^2)/(2*BW(1)^2)));
%osc = cos(2*pi*F*Freq);
env = exp(-((sin(theta)*(T-LAT(1)) -cos(theta)*(F-freq(1))).^2/(2*DUR^2) +...
            (cos(theta)*(T-LAT(1)) +sin(theta)*(F-freq(1))).^2/(2*BW(1)^2)));
osc = cos(2*pi*Freq*(cos(theta)*(T-LAT(1))+sin(theta)*(F-(theta ~= pi/2)*freq(1))));
g = osc.*env;

if postinh
  DUR2 = DUR*1.3;
  env = exp( -( ((T-LAT(2)).^2)/(2*DUR2^2) + ((F-1).^2)/(2*BW(2)^2)));

g = g - osc.*env/2;

end

out = g/abs(sum(g(:)));

