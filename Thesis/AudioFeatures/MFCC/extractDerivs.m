function deltaParams = extractDerivs(staticParams, confStruct, deltaOrAlpha)
% EXTRACTDERIVS - Extract derivative parameters from static parameters
%
% Usage: 
%       deltaParams = extractDerivs(staticParams, confStruct, deltaOrAlpha)
%
% Description: 
% Estimate derivative following HTK. Essentially derivative is estimated
% via regression.
%
% Input:
% staticParams : NxM array of data, M is the number of frames, N is the
%                dimensionality of the observations
% confStruct : configuration structure with fields DELTAWINDOW and
%               ACCWINDOW. They determine the window over which the
%               derivative and the acceleration respectively will be estimated.
% deltaOrAlpha : string that can be either 'delta' or 'alpha'. With
%                'delta', only derivatives are estimated while with 'alpha'
%                accelerations are found as well.
% 
% Example: 
% confStruct.DELTAWINDOW = 2;
% staticParams = [1 2 3 4; 4 5 6 7];
% deltaParams = extractDerivs(staticParams, confStruct, 'delta');
%


%deltaWin = str2num(confStruct.DELTAWINDOW);
if strcmp(deltaOrAlpha,'delta')
  deltaWin = confStruct.velwin;
  derivWin = deltaWin;
elseif strcmp(deltaOrAlpha, 'alpha')
  accWin = confStruct.accwin;
  derivWin = accWin;
end

sumOfSquareTheta = 0;
weighted_sumOfDiffs = 0;
c_t_upperLim = repmat(staticParams(:,end), 1, size(staticParams, 2));
c_t_lowerLim = repmat(staticParams(:,1), 1, size(staticParams, 2));

for theta=1:derivWin
  sumOfSquareTheta = theta^2 + sumOfSquareTheta;
  c_t_plus_theta = c_t_upperLim;
  c_t_sub_theta = c_t_lowerLim;
  
  c_t_plus_theta(:,1:end-theta) = staticParams(:,1+theta:end);
  c_t_sub_theta(:,1+theta:end) = staticParams(:,1:end-theta);
  
  weighted_sumOfDiffs = theta*(c_t_plus_theta - c_t_sub_theta) + weighted_sumOfDiffs;
end

deltaParams = weighted_sumOfDiffs/(2*sumOfSquareTheta);
