function [ ] = test( )
%Tests the socket linking

o = OMNeTPipe();
pk = OMNeTPk('header');
addVal(pk, 'a', 1, o.typeInt);

sendPk(o, pk);


end

