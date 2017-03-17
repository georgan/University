close all;
clear all;
f = imread('cornealendothel.png');
figure, imshow(f); title ('Original Image');

%------------Top-Hat-----------------------------
B = strel('square', 6);      %structing element
g1 = imtophat(f, B);         %peak operator
figure, imshow(g1); title ('Top-Hat Peaks');
thres = .15*max(g1(:));  
gout1 = (g1 > thres);        %apply thresholding
[L1, NUM1] = bwlabel(gout1); %computation of connective components
figure, imshow(gout1, []); title ('Binary Peaks');

%--------Contrast Reconstruction--------------------
h = 20;                     %maximum height
m = f - h;                  %markers
rho = imreconstruct(m, f);  %apply reconstruction opening
g2 = f - rho;               %dome operator
figure, imshow(g2); title('Contrast Reconstruction Peaks');
gout2 = (g2 >= h/2);        %apply thresholding
[L, NUM2] = bwlabel(gout2); %computation of connective components
figure, imshow(gout2); title ('Binary Peaks');