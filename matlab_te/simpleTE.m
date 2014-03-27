function [ F_4, P, Y_A3, V_L ] = simpleTE( s, u1, u2, u3, u4 )
%SIMPLETE Summary of this function goes here
%   Detailed explanation goes here
    y = [g11(s), 0,      0,      g14(s);
         g21(s), 0,      g23(s), 0;
         0,      g32(s), 0,      0;
         0,      0,      0,      g44(s)] * [u1;u2;u3;u4];
    F_4  = y(0);
    P    = y(1);
    Y_A3 = y(2);
    V_L  = y(3);
     
      
end

