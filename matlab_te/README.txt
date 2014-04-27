        
        % Constructor.  Uses nominal values to initialize, do this first.
        function obj = SimpleTE()
        
        % Get Outputs.  Returns the outputs of the current round of the TE
        % problem
        function [ y ] = getOutputs(obj)
        
        % Gets the nominal outputs
        function [ u ] = getNomInputs(obj)

        % Gets the nominal state values
        function [ x ] = getNomState(obj)

        % Gets the nominal outputs
        function [ y ] = getNomOutputs(obj)
        
        % Gets the current iteration's state values
        function [ x ] = getState(obj)

        % Gets the inputs given to create the current iteration
        function [ u ] = getLastInputs(obj)


        % Runs an iteration this takes in the TE object along with the new
        % inputs and a change in time
        function [ obj ] = runIteration( obj, u , dt)

   =========VARIABLE LIST========
        %% INPUTS (Actuators) %%
        % Desired positions of valves
        % Changes X_1-4
        u_1;
        u_2;
        u_3;
        u_4;
        
        %% OUTPUTS (Sensors) %%
        % In kmol h^-1
        % Feed 1-4 flow measurement
        F_1;
        F_2;
        % Purge flow measurement
        F_3;
        % Product flow measurement
        F_4;
        
        % Pressure
        P;
        
        % Liquid inventory % volume of system is liquid
        V_L;
        % percent Amount of A-C in purge
        y_a3;
        y_b3;
        y_c3;
        % Instantaneous cost
        C;
 
