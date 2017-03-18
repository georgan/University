function plotSVMboundary3( model, col, xplot, yplot, zplot)
%PLOTBOUNDARY Plots SVM surface
%   PLOTBOUNDARY3(MODEL) plots SVM decision curve for 3D data. MODEL is a
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
% 
%   PLOTBOUNDARY(MODEL,COL,XPLOT,YPLOT,ZPLOT) a vector that specifies the points
%   on z-axis that will be used to estimate the decision boundary. Use a
%   vector that covers the range of values of your data on z-axis. By
%   default ZPLOT = 0:.01:1 (data on [0,1] interval).

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

if nargin < 5
    zplot = 0:.01:1;
end

[X, Y, Z] = meshgrid(xplot, yplot, zplot);
vals = zeros(size(X));


somelab = ones(size(X(:,1)));
for i = 1:size(X, 2)
    for j = 1:size(X, 3)
        x = [X(:,i,j),Y(:,i,j), Z(:,i,j)];
   % Need to use evalc here to suppress LIBSVM accuracy printouts
   [T,predicted_labels, accuracy, decision_values] = ...
       evalc('svmpredict(somelab, x, model)');
   clear T;
   vals(:,i,j) = decision_values;
    end
end

% Plot the SVM boundary
colormap bone
% % % if (size(varargin, 2) == 1) && (varargin{1} == 't')
% % %     contourf(X,Y, vals, 50, 'LineStyle', 'none');
% % % end

% contour3(X,Y, vals, [0 0], 'LineWidth', 2, 'Color', col);
p = patch(isosurface(X,Y,Z,vals,0));
isonormals(X,Y,Z,vals,p);
set(p, 'FaceColor', col, 'EdgeColor', 'none');
view(3)
camlight; lighting phong

end

