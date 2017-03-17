clear all;
close all;

I = im2double(imread('edgetest_12.png'));       %insert image
%define parameters-----------------------------------------------------
PSNR = 20;                                      
sigmaGauss = 1.5;       %standar deviation of the Gaussian filter
thetaEdge = .2;
LaplacType = 1;         %LaplacType = 0 for linear
                        %LaplacType = 1 for non-linear
Imin = min(I(:));
Imax = max(I(:));
sigma = 10^(-PSNR/20)*(Imax - Imin);        %standard deviation of noise
%----------------------------------------------------------------------
J = imnoise(I, 'gaussian', 0, sigma^2);     %add gaussian noise to image
D = EdgeDetect(J, sigmaGauss, thetaEdge, LaplacType);   %call EdgeDetect, D = found edges

B = strel('diamond', 1);                    %define structuring element    
M = imdilate(I, B) - imerode(I, B);         %define outline
T = (M > thetaEdge);                        %find real edges

TandD = T & D;
PrTD = sum(TandD(:))/sum(D(:));             %Pr(T|D)
PrDT = sum(TandD(:))/sum(T(:));             %Pr(D|T)
C = .5*(PrTD + PrDT);                       

%plot results----------------------------------------------------------
figure;
subplot(2,2,1); imshow(I); title('Original');
subplot(2,2,2); imshow(J); title('Noise');
subplot(2,2,3); imshow(T); title('Real Edges');
subplot(2,2,4); imshow(D); title('Edges');