%% Format for packets
% HEADER => Type of request
% CHANGE -> Change the inputs
% UPDATE -> Update and get the latest version of the controls
% 
%
%
% ALWAYS ALWAYS ALWAYS
% node = int id
% All packets need
% dt = change in time since last sent packet
% id = identifier of system, starts at 1
%


%% Initialize TE
numTE = 1;
i = 1;
TE = [];
while (i <= numTE)
    TE(i) = SimpleTE();
    i = i + 1;
end


%% Startup pipe on port 18100
pipe = OMNeTPipe('localhost', 18240);


%% Recieve and iterate on packets
while (1 == 1)
    [header, pkMap] = recvPk(pipe);
    
    id = pkMap('id');
    dt = pkMap('dt');
    curTE = TE(id);
    
    % Do a change of inputs and outputs
    if (STRCMP(header, 'CHANGE'))      
        % Update the controls
        u = [pkMap('u1'), pkMap('u2'), pkMap('u3'), pkMap('u4')];
        y = runIteration(curTE, u, dt);
        
        % Send a packet containing the new input controls
        sendPk(pipe, 'CHANGE', id, pipe.typeInt, 'id', single(outputs(1)), pipe.typeFloat, 'F_1', single(outputs(2)), pipe.typeFloat, 'F_2', single(outputs(3)), pipe.typeFloat, 'F_3', single(outputs(4)), pipe.typeFloat, 'F_4', single(outputs(5)), pipe.typeFloat, 'P', single(outputs(6)), pipe.typeFloat, 'V_L', single(outputs(7)), pipe.typeFloat, 'y_a3', single(outputs(8)), pipe.typeFloat, 'y_b3', single(outputs(9)), pipe.typeFloat, 'y_c3', single(outputs(10)), pipe.typeFloat, 'C');
    % Get the inputs given the previous information
    elseif (STRCMP(header, 'UPDATE'))
        y = runIteration(curTE, getLastInputs(curTE), dt);
        sendPk(pipe, 'UPDATE', id, pipe.typeInt, 'id', single(outputs(1)), pipe.typeFloat, 'F_1', single(outputs(2)), pipe.typeFloat, 'F_2', single(outputs(3)), pipe.typeFloat, 'F_3', single(outputs(4)), pipe.typeFloat, 'F_4', single(outputs(5)), pipe.typeFloat, 'P', single(outputs(6)), pipe.typeFloat, 'V_L', single(outputs(7)), pipe.typeFloat, 'y_a3', single(outputs(8)), pipe.typeFloat, 'y_b3', single(outputs(9)), pipe.typeFloat, 'y_c3', single(outputs(10)), pipe.typeFloat, 'C');
    end
    
end