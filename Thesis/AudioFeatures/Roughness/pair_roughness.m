function [ R ] = pair_roughness( A, F, method )
%PAIR_ROUGHNESS Roughness of peaks pairs
%   R = PAIR_ROUGHNESS(A,F) computes roughness R because of pairs of peaks
%   on the spectrum of the signal. A and F are Dx2 matrices containing the
%   amplitudes and frequencies of the peaks, respectively. F is measured in
%   Hz. Roughness R is a Dx1 vector, where each row contains the rooughness
%   from the corresponding rows in A, F.
% 
%   R = PAIR_ROUGHNESS(A,F,method) allows you to choose which method to use
%   to compute the roughness of the pairs. Choices are:
%       'vassilakis' - use Vassilakis's method (default).
%       'sethares' - use Sethares's method which is simpler. The output of
%       this method is highly correlated to the energy of the signal.
% 
%   Example: if s = sin(2*pi*500*t)+.5*sin(2*pi*350*t)+.8*sin(2*pi*1000*t)
%   then the following code calculates the roughness of s.
%       A = [1 .5;1 .8; .5 .8];
%       F = [500 350; 500 1000; 350 1000];
%       r = pair_roughness(A, F, 'vassilakis');  %  roughness for each pair
%       R = sum(r);     % total roughness


if nargin < 3
    method = 'vassilakis';
end

if nargin < 2
    error('Not enough input arguments.');
end

if size(A,2)~=2 || length(size(A))~=length(size(F)) || any(size(A)~=size(F))
    error('A and F must be matrices with equal number of rows and two columns.');
end

if ~isnumeric(A) || ~isnumeric(F)
    error('A and F must be numerics.');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%

b1 = 3.5; b2 = 5.75;
s1 = .0207; s2 = 18.96;

s = .24./(s1*min(F(:,1),F(:,2))+s2);

dF = abs(F(:,1)-F(:,2));

X = A(:,1).*A(:,2);
Z = exp(-b1*s.*dF) - exp(-b2*s.*dF);


switch method
    case 'sethares'
        R = X.*Z;
    case 'vassilakis'
        Y = 2*min(A(:,1),A(:,2))./(A(:,1)+A(:,2));
        R = (X.^.1).*(Y.^3.11).*Z;
        R = .5*R;
    otherwise
        error('Invalid roughness estimation method.');
end

end

