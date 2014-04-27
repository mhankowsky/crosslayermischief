%% Format for packets
% HEADER => Type of request
% CHANGE -> Change the inputs (or in this case outputs of TE)
% UPDATE -> Update and get the latest version of the controls
% 
%
%
% ALWAYS ALWAYS ALWAYS
% node = int id
% All packets need
% dt = change in time since last sent packet
% id = identifier of controller, starts at 1
%


%% Initialize controllers
numControl = 1;
i = 1;

while (i <= numControl)
    control(i) = SimpleControl();
    i = i + 1;
end
host = 'localhost';
port = 18100;

%% Startup pipe on port 18100
pipe = OMNeTPipe(host, port);


%% Recieve and iterate on packets
while (1 == 1)
    [header, pkMap] = recvPk(pipe);
    id = pkMap('id');
    dt = pkMap('dt');
    curControl = control(id);
    % Do a change of inputs and outputs
    if (strcmp(header, 'CON_CHANGE'))      
        % Update the controls
        y = [pkMap('F_1'), pkMap('F_2'), pkMap('F_3'), pkMap('F_4'), pkMap('P'), pkMap('V_L'), pkMap('y_a3'), pkMap('y_b3'), pkMap('y_c3'), pkMap('C')];
        newCurControl = updateControls(curControl, y, dt);
        u = getInputsFromController(newCurControl);
        control(id) = newCurControl;

        % Send a packet containing the new input controls
        sendPk(pipe, 'SYS_CHANGE', id, pipe.typeInt, 'id',  single(dt), pipe.typeFloat, 'dt', single(u(1)), pipe.typeFloat, 'u1', single(u(2)), pipe.typeFloat, 'u2',single(u(3)), pipe.typeFloat, 'u3', single(u(4)), pipe.typeFloat, 'u4');
    % Get the inputs given the previous information
    elseif (strcmp(header, 'CON_UPDATE'))
        y = getLastInputsFromController(curControl);
        newCurControl = updateControls(curControl, y, dt);
        u = getInputsFromController(newCurControl);
        control(id) = newCurControl;
        
        sendPk(pipe, 'SYS_CHANGE', id, pipe.typeInt, 'id', single(dt), pipe.typeFloat, 'dt', single(u(1)), pipe.typeFloat, 'u1', single(u(2)), pipe.typeFloat, 'u2',single(u(3)), pipe.typeFloat, 'u3', single(u(4)), pipe.typeFloat, 'u4');
    end
    
end
