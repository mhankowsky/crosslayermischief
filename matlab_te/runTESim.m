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
    if (strcmp(header, 'SYS_CHANGE'))      
        % Update the controls
        u = [pkMap('u1'), pkMap('u2'), pkMap('u3'), pkMap('u4')];
        y = runIteration(curTE, u, dt);
        
        % Send a packet containing the new input controls
        sendPk(pipe, 'CON_CHANGE', id, pipe.typeInt, 'id',  single(dt), pipe.typeFloat, 'dt', single(y(1)), pipe.typeFloat, 'F_1', single(y(2)), pipe.typeFloat, 'F_2', single(y(3)), pipe.typeFloat, 'F_3', single(y(4)), pipe.typeFloat, 'F_4', single(y(5)), pipe.typeFloat, 'P', single(y(6)), pipe.typeFloat, 'V_L', single(y(7)), pipe.typeFloat, 'y_a3', single(y(8)), pipe.typeFloat, 'y_b3', single(y(9)), pipe.typeFloat, 'y_c3', single(y(10)), pipe.typeFloat, 'C');
    % Get the inputs given the previous information
    elseif (strcmp(header, 'SYS_UPDATE'))
        y = runIteration(curTE, getLastInputs(curTE), dt);
        sendPk(pipe, 'CON_CHANGE', id, pipe.typeInt, 'id', single(dt), pipe.typeFloat, 'dt', single(y(1)), pipe.typeFloat, 'F_1', single(y(2)), pipe.typeFloat, 'F_2', single(y(3)), pipe.typeFloat, 'F_3', single(y(4)), pipe.typeFloat, 'F_4', single(y(5)), pipe.typeFloat, 'P', single(y(6)), pipe.typeFloat, 'V_L', single(y(7)), pipe.typeFloat, 'y_a3', single(y(8)), pipe.typeFloat, 'y_b3', single(y(9)), pipe.typeFloat, 'y_c3', single(y(10)), pipe.typeFloat, 'C');
    end
    
end
