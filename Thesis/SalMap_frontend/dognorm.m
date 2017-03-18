function out = dognorm( in, Niter, L, prcnt, sigmas )
%DOGNORM Iterative DoG normalization
%   OUT = DOGNORM(IN) normalize input vector IN using iterative
%   normalization with Difference of Gaussians filter. If IN is a matrix,
%   DOGNORM performs normalization on each row of IN. IN must be of type
%   numeric. OUT is a matrix of the same size as IN, with the result of
%   normalization. Each row of OUT is the corresponding normalized row of
%   IN.
% 
%   OUT = DOGNORM(IN, Niter) controls the number of iterations to be
%   performed. Niter must be an integer scalar (default 15).
% 
%   OUT = DOGNORM(IN, Niter, L) specifies the length L of the DoG filter. L
%   must be an integer scalar (default 15).
% 
%   OUT = DOGNORM(IN, Niter, L, PRCNT) real scalar for the inhbition phase.
%   (default 0).
% 
%   OUT = DOGNORM(IN, Niter, L, PRCNT, SIGMAS) standard deviations of the
%   Gaussians. SIGMAS must be a two-elements vector of distinct positive
%   real numbers (default [1/12 1/20]). Note: the Gaussians are defined on
%   the [0,1] interval with mean value equal to 0.5. So SIGMAS must be
%   chosen properly.
% 
%   Example:
%       a = zeros(140,1);
%       i = 15;
%       a((51:70)-i) = 1;
%       a((31:50)-i) = (1:20)/20;
%       a((71:80)-i) = 1-(1:10)/10;
%       b = ((1:26) - 13)/13;
%       b = (b).^2;
%       b = 1-b;
%       a(101:126) = b;
% 
%       a_normal = dognorm(a, 12, 15);
%       figure
%       plot([a(:)/max(a) a_normal(:)/max(a_normal)]);
%       ylim([-.2 1.2]);
%       legend('Initial', 'Normalized')

%    References:
%       [1] L. Itti and C. Koch, "Feature combination strategies for saliency-based visual attention
%       systems," J. Electronic Imaging, vol. 10, no. 1, pp. 161–169, 2001.


if nargin < 5
    sigmas = [1/5 1/20];
    if nargin < 4
        prcnt = 0;
        if nargin < 3
            L = 15;
            if nargin < 2
                Niter = 15;
            end
        end
    end
end


if size(in, 2) ~= 1
    flag = 0;
else
    flag = 1;
    in = in';
end


dog = dogfilter(L, sigmas);

Lby2 = floor(L/2);
os = ones(1,Lby2);
in(:,Lby2+1:end+Lby2) = in;
in(:,1:Lby2) = in(:,1)*os;
in(:,end+1:end+Lby2) = in(:,end)*os;
% % in = [in(:,Lby2:-1:1) in in(:,end-Lby2+1:end)];


expr = 'out = out + a';
if prcnt ~= 0
    c_inh = prcnt*in;
    expr = [expr ' - c_inh'];
end
expr = [expr ';'];


out = in;
for i = 1:Niter
    a = conv2(1, dog, out, 'same');
    eval(expr);
    out = (out > 0).*out;
end

out = out(:,Lby2+1:end-Lby2);

if flag
    out = out';
end

end

