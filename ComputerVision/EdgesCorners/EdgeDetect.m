function D = EdgeDetect( I, sigma, thetaEdge, LaplacType )
% EdgeDetect Detects edges in a noisy image.
%   D = EdgeDetect(I, sigma, thetaEdge, LaplacType) Detects edges in the
%   noisy image I. The function filters the image with a Gaussian filter of
%   deviation sigma. thetaEdge is used as a threshold. If M is the maximum 
%   value of the magnitude of the image's gradient, then the magnitude of
%   the image's gradient in each point that is detected must be greater 
%   than thetaEdge*M. LaplacType is an integer that can have one of these 
%   values:
%
%       0           calculate Laplacian of image I using linear approach.
%
%       1           calculate Laplacian of image I using non-linear
%                   approach.


if nargin ~= 4                                  %check for right number of input arguments
    error('Wrong number of input arguments.');
end

n = ceil(3*sigma)*2 + 1;                        %define size of the filter
B = strel('diamond', 1);                        %define structuring element

filtGauss = fspecial('gaussian', n, sigma);     %define Gaussian filter
Isigma = imfilter(I, filtGauss, 'replicate');   %convolution with Gaussian-smoothens the image
%------------------Laplace computation-------------------------------------------
if LaplacType == 1                              %non-linear approach
    Idil = imdilate(Isigma, B);
    Iero = imerode(Isigma, B);
    L = Idil + Iero - 2*Isigma;
else                                            %linear approach
    filtLog = fspecial('log', n, sigma);        %Laplacian-of-Gaussian filter
    L = conv2(I, filtLog, 'same');              
end
%--------------------------------------------------------------------------

X = (L >= 0);                                   %sign image
Xdil = imdilate(X, B);
Xero = imerode(X, B);
Y = Xdil - Xero;                                %outline of the image
[FX, FY] = gradient(Isigma);                    %partial derivatives
abs_grad_Isigma = sqrt(FX.^2 + FY.^2);          %gradient magnitude
M = max(abs_grad_Isigma(:));
D = Y & (abs_grad_Isigma > thetaEdge*M);        %output=edges
end

