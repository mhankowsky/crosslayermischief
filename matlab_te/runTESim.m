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
while (i <= numTE)
    TE(i) = SimpleTE();
    i = i + 1;
end

host = 'localhost';
port = 18240;

%% Startup pipe on port 18240
pipe = OMNeTPipe(host, port);

%% Recieve and iterate on packets
while (1 == 1)
    [header, pkMap] = recvPk(pipe);
    
    id = pkMap('id');
    dt = pkMap('dt');
    curTE = TE(id);
    
    % Do a change of inputs and outputs
    if (strcmp(header, 'CHANGE'))      
        % Update the controls
        u = [pkMap('u1'), pkMap('u2'), pkMap('u3'), pkMap('u4')]
        newCurTE = runIteration(curTE, u, dt);
        y = getOutputs(newCurTE);
        TE(id) = newCurTE;

        % Send a packet containing the new input controls
        sendPk(pipe, 'CHANGE', id, pipe.typeInt, 'id', (dt), pipe.typeFloat, 'dt', (y(1)), pipe.typeFloat, 'F_1', (y(2)), pipe.typeFloat, 'F_2', (y(3)), pipe.typeFloat, 'F_3', (y(4)), pipe.typeFloat, 'F_4', (y(5)), pipe.typeFloat, 'P', (y(6)), pipe.typeFloat, 'V_L', (y(7)), pipe.typeFloat, 'y_a3', (y(8)), pipe.typeFloat, 'y_b3', (y(9)), pipe.typeFloat, 'y_c3', (y(10)), pipe.typeFloat, 'C', (u(1)), pipe.typeFloat, 'u1', (u(2)), pipe.typeFloat, 'u2', (u(3)), pipe.typeFloat, 'u3', (u(4)), pipe.typeFloat, 'u4');
    % Get the inputs given the previous information
    elseif (strcmp(header, 'UPDATE'))
        u = getLastInputs(curTE); 
        newCurTE = runIteration(curTE, u, dt);
        y = getOutputs(newCurTE);
        TE(id) = newCurTE;
        

        sendPk(pipe, 'CHANGE', id, pipe.typeInt, 'id', (dt), pipe.typeFloat, 'dt', (y(1)), pipe.typeFloat, 'F_1', (y(2)), pipe.typeFloat, 'F_2', (y(3)), pipe.typeFloat, 'F_3', (y(4)), pipe.typeFloat, 'F_4', (y(5)), pipe.typeFloat, 'P', (y(6)), pipe.typeFloat, 'V_L', (y(7)), pipe.typeFloat, 'y_a3', (y(8)), pipe.typeFloat, 'y_b3', (y(9)), pipe.typeFloat, 'y_c3', (y(10)), pipe.typeFloat, 'C', (u(1)), pipe.typeFloat, 'u1', (u(2)), pipe.typeFloat, 'u2', (u(3)), pipe.typeFloat, 'u3', (u(4)), pipe.typeFloat, 'u4');
    end
    
end
