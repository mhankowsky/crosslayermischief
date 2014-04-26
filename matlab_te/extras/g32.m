function [ y ] = g32( s )
%SIMPLETE Summary of this function goes here
%   Detailed explanation goes here

y = (1.5 / (10 .* s + 1)) .* exp(-0.1 .* s);

end