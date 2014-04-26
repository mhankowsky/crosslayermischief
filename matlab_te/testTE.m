pipe = OMNeTPipe();
[header, pkMap] = recvPk(pipe);
u = [pkMap('u1'), pkMap('u2'), pkMap('u3'), pkMap('u4')];
dt = pkMap('dt');

te = SimpleTE();
te = runIteration(te, u, dt);
outputs = getOutputs(te);

% Val, ValType, Name
sendPk(pipe, 'OUTPUT', single(outputs(1)), pipe.typeFloat, 'F_1', single(outputs(2)), pipe.typeFloat, 'F_2', single(outputs(3)), pipe.typeFloat, 'F_3', single(outputs(4)), pipe.typeFloat, 'F_4', single(outputs(5)), pipe.typeFloat, 'P', single(outputs(6)), pipe.typeFloat, 'V_L', single(outputs(7)), pipe.typeFloat, 'y_a3', single(outputs(8)), pipe.typeFloat, 'y_b3', single(outputs(9)), pipe.typeFloat, 'y_c3', single(outputs(10)), pipe.typeFloat, 'C');

[header, pkMap] = recvPk(pipe);

pkMap('ack')