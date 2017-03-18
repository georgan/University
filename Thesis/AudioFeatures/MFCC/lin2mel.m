function [ m ] = lin2mel( f )
%LIN2MEL linear to mel scale
%   f: frequency in Hz
%   m: frequency in Mel

m = 2595*log10(f/700+1);

end

