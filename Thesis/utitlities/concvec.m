function [ b ] = concvec( a, t, olap )
%CONCVEC Concatenate vectors
%   B = CONCVEC(A,t) concatenates t elements of vector A, to create a
%   vector. If A is a matrix concatenation of t columns of A is made. B is
%   a matrix with dimensions round([t*size(A,1),size(A,2)/t]) with the
%   result of the concatenation. No overlap beteen successive vectors is
%   applied.
% 
%   B = CONCVEC(A,t,olap) applies overlap olap (in samples) between
%   successive elements.


if nargin < 3
    olap = 0;
end

if numel(t)>1 || floor(t)~=t || t<1
    error('t must be a positive integer.');
end

[ndims, nframes] = size(a);

if nframes==1
    a = a';
end

%-------- Initial Version -----------
% % % % m = mod(nframes,t);
% % % % if m >= t/2
% % % %     a = [a a(:,end:-1:end-t+m+1)];
% % % %     nframes = nframes+t-m;
% % % % else
% % % %     a = a(:,1:end-m);
% % % %     nframes = nframes-m;
% % % %     if m > 0
% % % %         fprintf(1, sprintf('throwing %d frames...\n', m));
% % % %     end
% % % % end
% % % % 
% % % % % size(a)
% % % % % t*ndims, nframes/t
% % % % b = reshape(a, t*ndims, nframes/t);


nframes = nframes*ndims;
olap = olap*ndims;
t = t*ndims;
a = a(:)';

m = mod(nframes-t,t-olap);
if m > 0
    if olap+m >= t/2
        a = [a a(end:-1:end-t+olap+m+1)];
    else
        a = a(1:end-m);
        fprintf(1, sprintf('throwing %d frames...\n', m/ndims));
    end
end

b = buffer(a,t,olap,'nodelay');



end

