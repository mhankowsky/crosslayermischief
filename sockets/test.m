function [ ] = test( )
%Tests the socket linking
disp('Starting test, connecting....')
o = OMNeTPipe();
disp('Connected')
while (1 == 1)
    disp(' Reading new packet')
    [h, v] = recvPk(o);
    disp(' Packet received:')
    dips(h)
    disp(v('t'))
end   

end

