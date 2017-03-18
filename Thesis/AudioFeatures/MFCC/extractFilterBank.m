function filterBank = extractFilterBank( params )
%extractFilterBank extract Mel filterbank
% Input:
%   params: a structure with parameters to extract filterbank, which is
%   returned from confstruct function.
%   filterbank: the filterbank where each row contains the frequency
%   response of a filter.


r = params.fs/params.Nfft;
filterBank = zeros(params.Q, params.Nfft/2);
cfmel = (0:(params.Q+1))*2595*log(1+params.fs/(2*700))/(params.Q+1);
f0 = 700*(exp(cfmel(1)/2595)-1);
f1 = 700*(exp(cfmel(2)/2595)-1);

for i = 1:params.Q
    f2 = 700*(exp(cfmel(i+2)/2595)-1);
    
    filterBank(i,ceil(f0/r)+1:ceil(f1/r)) = (0:(ceil(f1/r)-ceil(f0/r)-1))/(ceil(f1/r)-ceil(f0/r)-1);
    filterBank(i,(ceil(f1/r)+1):floor(f2/r)) = ((floor(f2/r)-ceil(f1/r)-1):-1:0)/(floor(f2/r)-ceil(f1/r));
%     filterBank(i,:) = filterBank(i,:)/sum(filterBank(i,:));
    filterBank(i,:) = filterBank(i,:)/(f2-f0);

    f0 = f1;
    f1 = f2;
end

