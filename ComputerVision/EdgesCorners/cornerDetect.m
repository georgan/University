I = rgb2gray(im2double(imread('corners1.png')));    %read image
%define parameters-----------------------------------------
sigma = 1.3;            %deviation of Gaussian filter(differentiation scale)
rho = 3;                %deviation of Gaussian filter(integration scale)
k = 0.05;               %cornerness criterion constant
theta_corn = .01;       %threshold

%----------------------------------------------------------
n1 = ceil(3*sigma)*2 + 1;                   %dimensions of Gaussian filters
n2 = ceil(3*rho)*2 + 1;

Gsigma = fspecial('gaussian', n1, sigma);   %create gaussian filters
Grho = fspecial('gaussian', n2, rho);

Isigma = conv2(I, Gsigma, 'same');          %smoothing image
[FX, FY] = gradient(Isigma);                %calculate image gradient

Ix = FX.^2;                                 %calculate elements of matrix
Ixy = FX.*FY;                               % J = [J1 J2; J2 J3]
Iy = FY.^2;
J1 = conv2(Ix, Grho, 'same');
J2 = conv2(Ixy, Grho, 'same');
J3 = conv2(Iy, Grho, 'same');

lambda1 = .5*(J1 + J3 + sqrt((J1 - J3).^2 + 4*J2.^2));  %calculate eigenvalues of J
lambda2 = .5*(J1 + J3 - sqrt((J1 - J3).^2 + 4*J2.^2));

R = lambda1.*lambda2 - k*(lambda1 + lambda2).^2;    %calculate cornerness criterion
Rmax = max(R(:));
B_sq = strel('square', 3);                          %define structuring element

Cond1 = (R == imdilate(R, B_sq));                   %conditions for corners
Cond2 = (R > theta_corn*Rmax);
Corners = Cond1 & Cond2;                            %image corners
imgNcorns = markCorn(I, Corners, [1,0,0], 2);

%plot results---------------------------------------------------
figure;
subplot(1,2,1); imshow(lambda1, []); title('Eigenvalue Lambda_+');
subplot(1,2,2); imshow(lambda2, []); title('Eigenvalue Lambda_-');
figure; imshow(R, []); title('Cornerness Criterion');
figure;
subplot(1,2,1); imshow(I); title('Input Image');
subplot(1,2,2); imshow(imgNcorns); title('Corners');