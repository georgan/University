function plotSVMboundary( model, col, xplot, yplot)
%PLOTBOUNDARY Plots SVM curve
%   PLOTBOUNDARY(MODEL) plots SVM decision curve for 2D data. MODEL is a
%   structure that is returned by the svmtrain function of LIBSVM package.
%   Plot is made on the current axis.
% 
%   PLOTBOUNDARY(MODEL,COL) speficies the color of the surface. It can be a
%   string with the color or a three-elements vector with the RGB value.
%   (default 'g').
% 
%   PLOTBOUNDARY(MODEL,COL,XPLOT) a vector that specifies the points on
%   x-axis that will be used to estimate the decision boundary. Use a
%   vector that covers the range of values of your data on x-axis. By
%   default XPLOT = 0:.01:1 (data on [0,1] interval).
%
%   PLOTBOUNDARY(MODEL,COL,XPLOT,YPLOT) a vector that specifies the points
%   on y-axis that will be used to estimate the decision boundary. Use a
%   vector that covers the range of values of your data on y-axis. By
%   default YPLOT = 0:.01:1 (data on [0,1] interval).


% Make classification predictions over a grid of values

if nargin < 2
    col = 'g';
end

if nargin < 3
    xplot = 0:.01:1;
end
if nargin < 4
    yplot = 0:.01:1;
end


[X, Y] = meshgrid(xplot, yplot);
vals = zeros(size(X));


somelab = ones(size(X(:,1)));
for i = 1:size(X, 2)
   x = [X(:,i),Y(:,i)];
   % Need to use evalc here to suppress LIBSVM accuracy printouts
   [T,predicted_labels, accuracy, decision_values] = ...
       evalc('svmpredict(somelab, x, model)');
   clear T;
   vals(:,i) = decision_values;
end

% Plot the SVM boundary
colormap bone
% % if (size(varargin, 2) == 1) && (varargin{1} == 't')
% %     contourf(X,Y, vals, 50, 'LineStyle', 'none');
% % else

contour(X,Y, vals, [0 0], 'LineWidth', 2, 'Color', col);

end

