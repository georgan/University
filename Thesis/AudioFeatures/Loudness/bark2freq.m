function [ freq ] = bark2freq( z )
%BARK2FREQ Bark scale to frequency scale.
%   FREQ = BARK2FREQ(Z) Computes frequency FREQ in Hz from frequency Z in
%   Bark. Z and FREQ are numeric arrays of the same size.

z = double(z);
freq = 650*sinh(z/7);

end

