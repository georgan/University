close all;
clear all;
frames = 59;            %number of frames

%------------------Skin Parameters-------------------------------------
load skinSamplesRGB.mat;        %load skin samples for training
skinSamplesYCbCr = double(rgb2ycbcr(skinSamplesRGB));
meancb = mean2(skinSamplesYCbCr(:,:,2));        %calculate mean of gaussian
meancr = mean2(skinSamplesYCbCr(:,:,3));
m = [meancb meancr];
cb = skinSamplesYCbCr(:,:,2);
cr = skinSamplesYCbCr(:,:,3);
sxy = cov(cb(:), cr(:));                  %calculate covariance of gaussian
I = imread('GSLframes/1.png');

%------------------Plot Gaussian Surface-------------------------------
[x, y] = meshgrid(1:size(I,2), 1:size(I,1));
x = x - m(1);
y = y - m(2);
sinv = inv(sxy);
g = 1/sqrt(det(sxy)*2*pi)*exp(-sinv(1,1)/2*x.^2 - sinv(1,2)*x.*y - sinv(2,2)/2*y.^2);
figure, surf(g), title('Gaussian');

%------------------Face Detection------------------------------------
box = fd(I, m, sxy);
x = box(1);             %(x,y) left upper corner coordinates 
y = box(2);
w = box(3);             %box width
h = box(4);             %box height

%------------Initialize Algorithm Parameters---------------------------
rho = 5;                %gaussian deviation
epsilon = .04;          %correction term
dx_0 = zeros(h+1, w+1);     %(dx_0,dy_0): initial dispacement estimation
dy_0 = dx_0;
load groundtruthDisplacement.mat;   %load true dispalcements
gtD = groundtruthDisplacement;
displacement = zeros(frames, 2);

fig = figure;
savim = 0;
video = 1;
if(video), avi_out = avifile(['face.avi'], 'FPS', 7, 'COMPRESSION', 'None'); end

%--------------Apply Lucas-Kanade Algorithm for every frame-------------
Jprev = I;
for i = 1:frames
    s = sprintf('GSLframes/%d.png', i+1);
    ftitle = sprintf('Frame %d', i+1);
    
    Jnext = imread(s);
    J1 = Jprev(y:y+h,x:x+w,:);          %crop images according to bounding box
    J2 = Jnext(y:y+h,x:x+w,:);
    
    [dx, dy] = lk(J1, J2, rho, epsilon, dx_0, dy_0);    %Lucas Kanade algorithm
    [displ_x, displ_y] = displ(dx, dy);     %Box dispacement
    x = x - displ_x;                        %new Box coordinates
    y = y - displ_y;
    displacement(i, :) = [-displ_x, -displ_y];  %store displacements
    dx_r = imresize(dx, .3); dy_r = imresize(dy, .3);   %downsampling
    U = dx.^2 + dy.^2;                            %energy of flow vectors
    
    subplot(1,3,1), quiver(-dx_r, -dy_r), axis('image');     %plot vector field
    subplot(1,3,2), imshow(U, []), title(ftitle);            %plot energy
    subplot(1,3,3), imshow(Jnext), axis('image'), hold on;   %plot image
    
    p = rectangle('Position', [x y w h]);       %add rectangle to image
    set(p, 'EdgeColor', [1,0,0], 'LineWidth', 2);
    
    F = getframe(fig);
	if(video), avi_out = addframe(avi_out, F); end
    
    if (savim), saveas(fig, sprintf('images/frame%d.png', i+1)); end
    Jprev = Jnext;
end

%-----------------Calculate Errors------------------------------------
error = gtD - displacement;
E = mse(error);                         %mean square error

s = zeros(frames,2);
s(1,:) = error(1,:);
for i = 2:frames
    s(i,:) = s(i-1,:) + error(i,:);     %Box position error
end

%--------------Plot Errors--------------------------------------------
n = 1:frames;
figure, plot(n, error(:,1)),...
title('Estimation Error in x-direction'), xlabel('Frame'), ylabel('Error in pixels');
figure, plot(n, error(:,2)),...
title('Estimation Error in y-direction'), xlabel('Frame'), ylabel('Error in pixels');

figure, plot(n, s(:,1)),...
title('Error in x-direction'), xlabel('Frame'), ylabel('Error in pixels');
figure, plot(n, s(:,2)),...
title('Error in y-direction'), xlabel('Frame'), ylabel('Error in pixels');