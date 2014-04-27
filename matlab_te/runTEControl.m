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
port = 18100;

%% Startup pipe on port 18100
pipe = OMNeTPipe(18100);


%% Recieve and iterate on packets
while (1 == 1)
    [header, pkMap] = recvPk(pipe);
    ischar(header)
    id = pkMap('id');
    dt = pkMap('dt');
    curControl = control(id);
    % Do a change of inputs and outputs
    
    if (strcmp(header, 'CHANGE'))      
        % Update the controls
        y = [pkMap('F_1'), pkMap('F_2'), pkMap('F_3'), pkMap('F_4'), pkMap('P'), pkMap('V_L'), pkMap('y_a3'), pkMap('y_b3'), pkMap('y_c3'), pkMap('C')];
        u = updateControls(curControl, y, dt);
        u
        % Send a packet containing the new input controls
        sendPk(pipe, 'CHANGE', id, pipe.typeInt, 'id',  single(dt), pipe.typeFloat, 'dt', single(u(1)), pipe.typeFloat, 'u1', single(u(2)), pipe.typeFloat, 'u2',single(u(3)), pipe.typeFloat, 'u3', single(u(4)), pipe.typeFloat, 'u4');
    % Get the inputs given the previous information
    elseif (strcmp(header, 'UPDATE'))
        y = getLastInputsFromController(curControl);
        u = updateControls(curControl, y, dt);
        u
        sendPk(pipe, 'CHANGE', id, pipe.typeInt, 'id', single(dt), pipe.typeFloat, 'dt', single(u(1)), pipe.typeFloat, 'u1', single(u(2)), pipe.typeFloat, 'u2',single(u(3)), pipe.typeFloat, 'u3', single(u(4)), pipe.typeFloat, 'u4');
    end
    
end