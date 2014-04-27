classdef SimpleControl
    %TECLASS Simplified Tennessee Eastman Problem Controller
    
    properties
        setpts;         % setpoint are initialized to measurements

        errn1;          % initialize integral errors to zero

        % similarly for pressure override loop

        errn1PC;
        F4sp_adj;
        F4sp;
        up;
        y_old;
    end
    methods (Static)
         %% Constructor
        function obj = SimpleControl()
            % Constants
            KcPC   = 0.7;
            TauiPC = 3;
            tauis  = [1.0, 1.5, 3.0];  % integral times
            Kcs    = [.1, -.25, 2.0];  % gains
            iydisp = [4:9];            % indeces of displayed outputs
            icv    = [4,5,7];          % indeces of controlled outputs
            imv    = [1,3,2];          % indeces of manipulated inputs
            
            
            % Initial output vector
            nom_F_1 = 201.43;
            nom_F_2 = 5.62;
            nom_F_3 = 7.05;
            nom_F_4 = 100.00;
            nom_P = 2700.00;
            nom_V_L = 44.18;
            nom_y_a3 = 47.00;
            nom_y_b3 = 14.29;
            nom_y_c3 = 38.71;
            nom_C = 0.2415;
            
            y0(1)  = nom_F_1;
            y0(2)  = nom_F_2;
            y0(3)  = nom_F_3;
            y0(4)  = nom_F_4;
            y0(5)  = nom_P;
            y0(6)  = nom_V_L;
            y0(7)  = nom_y_a3;
            y0(8)  = nom_y_b3;
            y0(9)  = nom_y_c3;
            y0(10) = nom_C;
            obj.y_old = y0;
            
            % Initialize nominal values
            % Define parameters for the basic control loops:

            iydisp = [4:9];            % indeces of displayed outputs
            icv    = [4,5,7];          % indeces of controlled outputs
            imv    = [1,3,2];          % indeces of manipulated inputs
            obj.setpts = y0(icv);     % setpoint are initialized to measurements
            obj.errn1 = zeros(1, length(Kcs));  % initialize integral errors to zero

            % similarly for pressure override loop
            obj.errn1PC  = 0;
            obj.F4sp_adj = 0;
            obj.F4sp     = [];
            
            % Initialize up
            [x0, VL] = SimpleControl.TESteadyState();
            VLpct = VL * 100 / 30;
            u0 = [];
            u0(1:3, 1) = x0(5:7, :);
            u0(4) = VLpct;
            obj.up = u0;
            
        end
        
        
        
        function [x,VL]=TESteadyState()

            % [x,VL]=te_4_ss(ya3,F4,P,p1)
            %
            % Finds a steady-state of the 2-phase reactor for
            % the following specified conditions:
            %
            % ya3   mol fraction of A in purge
            % F4    product rate (kmol/h)
            % P     pressure (kPa)
            % p1    parameter vector.  See TE_4.f for details.
            %
            % where x and VL are the calculated steady-state
            % values of the states and the liquid volume (m^3),
            % respectively.

            % copyright N. L. Ricker
            % University of Washington
            % Chemical Engineering
            % Box 351750
            % Seattle, WA 98195-1750
            % ricker@cheme.washington.edu

            % Constant Parameters
            kpar  = 0.00117;
            nCPar = 0.4;
            P     = 2700;
            F4    = 100;
            ya3   = 0.47;
                    
            % Get yc3 from production rate        
            
            Pa  = P * ya3;
            Pc  = (F4 / (kpar * (Pa ^ 1.2))) ^ (1 / nCPar);
            yc3 = Pc / P;
            Pb  = P - Pa - Pc;
            yb3 = Pb / P;

            ya1 = 0.485;
            yb1 = 0.005;
            yc1 = 1 - ya1 - yb1;

            % Solve mat. bal. eqns. for flowrates

            A = [ya1 1 -ya3
                 yb1 0 -yb3
                 yc1 0 -yc3];
            b = [F4
                 0
                 F4];

            F = A \ b;

            Cv = [3.3046, 0.2246, 0.00352, 0.0417];

            x(5, 1) = F(1) / Cv(1);
            x(6, 1) = F(2) / Cv(2);
            x(7, 1) = F(3) / (Cv(3) * sqrt(P - 100));
            x(8, 1) = F4 / (Cv(4) * sqrt(P - 100));

            Nd = 110;
            VL = Nd / 8.3;
            x(4, 1) = Nd;
            VV = 122 - VL;
            NV = P * VV / (8.314 * 373);
            x(1, 1) = NV * ya3;
            x(2, 1) = NV * yb3;
            x(3, 1) = NV * yc3;
        end    
    end
    methods
       

        %% Run a simple controller that looks at outputs to find inputs
        %  This takes in the controller object, as well as the output
        %  vector and dt since last run.
        %
        %
        % This code was borrowed and partially modified from: 
        % N. L. Ricker
        % University of Washington
        % Chemical Engineering
        % Box 351750
        % Seattle, WA 98195-1750
        % ricker@cheme.washington.edu
        function [ new_obj ] = updateControls(obj, y, dt)
            %F_1  = y(1);
            %F_2  = y(2);
            %F_3  = y(3);
            %F_4  = y(4);
            %P    = y(5);
            %V_L  = y(6);
            %y_a3 = y(7);
            %y_b3 = y(8);
            %y_c3 = y(9);
            %C    = y(10);
            
            % Constants
            KcPC   = 0.7;
            TauiPC = 3;
            tauis  = [1.0, 1.5, 3.0];  % integral times
            Kcs    = [.1, -.25, 2.0];  % gains
            iydisp = [4:9];            % indeces of displayed outputs
            icv    = [4,5,7];          % indeces of controlled outputs
            imv    = [1,3,2];          % indeces of manipulated inputs
            
            
            % Get current plant outputs
            yp = y;

            % Pressure control override loop
            errnPC        = 2900 - yp(5);
            obj.F4sp_adj  = min([obj.F4sp_adj + KcPC * (errnPC - obj.errn1PC + (dt * errnPC) / TauiPC), 0]);
            obj.errn1PC   = errnPC;
            setpts_save   = obj.setpts;
            obj.setpts(1) = obj.setpts(1) + obj.F4sp_adj;
        
            % PI control
            errn               = obj.setpts - yp(icv);
            delu               = Kcs .* (errn - obj.errn1 + (dt * errn) ./ tauis);
            obj.up(imv, 1)     = obj.up(imv, 1) + delu(1:3)';
            obj.errn1          = errn;
            obj.up(imv, 1)     = min([max([obj.up(imv, 1)'; zeros(1, 3)]); 100 * ones(1, 3)])';
           
            % Restore setpoints to original values
            obj.setpts = setpts_save;
            
            % Save the outputs that were inputted
            obj.y_old = y;
            
            % Set inputs at end (to TE)
            u = obj.up;
            new_obj = obj;
        end
        
        function [ u ] = getInputsFromController(obj)
            u = obj.up;
        end
        
        function [ y ] = getLastInputsFromController(obj)
            y = obj.y_old;
        end

    end
    
end

