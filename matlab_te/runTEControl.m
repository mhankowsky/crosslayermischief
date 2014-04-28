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
    if (strcmp(header, 'CHANGE'))      
        % Update the controls
        y = [pkMap('F_1'), pkMap('F_2'), pkMap('F_3'), pkMap('F_4'), pkMap('P'), pkMap('V_L'), pkMap('y_a3'), pkMap('y_b3'), pkMap('y_c3'), pkMap('C')];
        newCurControl = updateControls(curControl, y, dt);
        u = getInputsFromController(newCurControl);
        control(id) = newCurControl;

        % Send a packet containing the new input controls
        sendPk(pipe, 'STATUS', id, pipe.typeInt, 'id', (dt), pipe.typeFloat, 'dt', (y(1)), pipe.typeFloat, 'F_1', (y(2)), pipe.typeFloat, 'F_2', (y(3)), pipe.typeFloat, 'F_3', (y(4)), pipe.typeFloat, 'F_4', (y(5)), pipe.typeFloat, 'P', (y(6)), pipe.typeFloat, 'V_L', (y(7)), pipe.typeFloat, 'y_a3', (y(8)), pipe.typeFloat, 'y_b3', (y(9)), pipe.typeFloat, 'y_c3', (y(10)), pipe.typeFloat, 'C', (u(1)), pipe.typeFloat, 'u_1', (u(2)), pipe.typeFloat, 'u_2', (u(3)), pipe.typeFloat, 'u_3', (u(4)), pipe.typeFloat, 'u_4');
    % Get the inputs given the previous information
    elseif (strcmp(header, 'UPDATE'))
        y = getLastOutputsFromController(curControl);
        newCurControl = updateControls(curControl, y, dt);
        u = getInputsFromController(newCurControl);
        control(id) = newCurControl;
        u
        y
        sendPk(pipe, 'STATUS', id, pipe.typeInt, 'id', (dt), pipe.typeFloat, 'dt', (y(1)), pipe.typeFloat, 'F_1', (y(2)), pipe.typeFloat, 'F_2', (y(3)), pipe.typeFloat, 'F_3', (y(4)), pipe.typeFloat, 'F_4', (y(5)), pipe.typeFloat, 'P', (y(6)), pipe.typeFloat, 'V_L', (y(7)), pipe.typeFloat, 'y_a3', (y(8)), pipe.typeFloat, 'y_b3', (y(9)), pipe.typeFloat, 'y_c3', (y(10)), pipe.typeFloat, 'C', (u(1)), pipe.typeFloat, 'u_1', (u(2)), pipe.typeFloat, 'u_2', (u(3)), pipe.typeFloat, 'u_3', (u(4)), pipe.typeFloat, 'u_4');
    end
    
end
