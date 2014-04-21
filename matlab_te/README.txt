        
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
