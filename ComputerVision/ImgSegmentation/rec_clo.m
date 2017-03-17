function res = rec_clo( marker, I )
%REC_CLO Reconstruction closing
%   IM = REC_CLO(marker, I) performs reconstruction closing of the image
%   marker under the image I.  marker and I can be two intensity images
%   or two binary images with the same size; IM is an intensity or binary
%   image, respectively.  marker must be the same size as I, and its
%   elements must be greater than or equal to the corresponding elements of
%   I.
%
%  By default, REC_CLO uses 8-connected neighborhoods for 2-D
%  images and 26-connected neighborhoods for 3-D images.
 


res = imcomplement(imreconstruct(imcomplement(marker), imcomplement(I)));


end

