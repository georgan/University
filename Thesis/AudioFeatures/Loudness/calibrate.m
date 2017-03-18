function [ x ] = calibrate( x, Pref )
%CALIBRATE Calibrates Pressure level
%   Y = CALIBRATE(X) scales signal X to pressure level of 20 micropascals,
%   which is the reference level for air.
% 
%   Y = CALIBRATE(X,Pref) scales X to the desired pressure level Pref.

if nargin < 2
    Pref = 20e-6; % 20 microPascals
end

if ~isnumeric(Pref) || length(Pref)>1 || Pref<=0
    error('Pref must be a numeric positive scalar.');
end

x = x/Pref;


end

