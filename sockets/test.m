function [ ] = test( )
%Tests the socket linking
disp('Starting test, connecting....')
o = OMNeTPipe();
disp('Connected')
while (TRUE)
    disp(' Reading new packet')
    [h, v] = o.rcvPk(o);
    disp(' Packet received:')
    dips(h)
    disp(v('t'))
end    

end

