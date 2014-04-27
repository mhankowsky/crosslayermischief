classdef SimpleTE
    %TECLASS Simplified Tennessee Eastman Problem
    %   The system takes in three vectors
    %   The Input vector u which decides the valve positions
    %   The State vector x which decides the current state
    %   The Time vector which decides the time elapsed
    
    properties
        %% State variables
        % In kmols
        nom_N_a = 44.49999958429348;
        nom_N_b = 13.53296996509594;
        nom_N_c = 36.64788062995841;
        nom_N_d = 110.0;
        % In percentage
        nom_X_1 = 60.95327313484253;
        nom_X_2 = 25.02232231706676;
        nom_X_3 = 39.25777017606444;
        nom_X_4 = 47.03024823457651;
        
        % Molar holdup of A
        N_a;
        % Molar holdup of B
        N_b;
        % Molar holdup of C
        N_c;
        % Molar Holdup of D
        N_d;
        % Feed 1 valve position
        X_1;
        % Feed 2 valve position
        X_2;
        % Purge valve position
        X_3;
        % Product valve position
        X_4;
        
        
        
        %% Manipulated Variables
        % Can range from 0-100%
        nom_u_1 = 60.95327313484253;
        nom_u_2 = 25.02232231706676;
        nom_u_3 = 39.25777017606444;
        nom_u_4 = 44.17670682730923;
        
        
        
        % Desired positions of valves
        % Changes X_1
        u_1;
        % Changes X_2
        u_2;
        % Changes X_3
        u_3;
        % Changes X_4
        u_4;
        
        %% Outputs
        % In kmol h^-1
        nom_F_1 = 201.43;
        nom_F_2 = 5.62;
        nom_F_3 = 7.05;
        nom_F_4 = 100.00;
        % In kPa
        nom_P = 2700.00;
        % In % of max
        nom_V_L = 44.18;
        % In mol percentage
        nom_y_a3 = 47.00;
        nom_y_b3 = 14.29;
        nom_y_c3 = 38.71;
        % in $/kmol
        nom_C = 0.2415;
        
        % Feed 1 flow measurement
        % 0 - 330.46
        F_1;
        % Feed 2 flow measurement
        % 0 - 22.46
        F_2;
        % Purge flow measurement
        % Range based on equation 15
        F_3;
        % Product flow measurement
        % Range based on equation 15
        F_4;
        % Pressure
        % < 3000
        P;
        % Liquid inventory % volume of system is liquid
        % 0-100
        V_L;
        % percent Amount of A in purge
        % 0-100
        y_a3;
        % percent Amount of B in purge
        % 0-100
        y_b3;
        % percent amount of C in purge
        y_c3;
        % Instantaneous cost
        % 0-?
        C;
        
        %% Disturbance variables
        % Mole fraction in Feed 1
        y_a1 = 0.485;
 
        % Mole fraction in Feed 2
        y_b1 = 0.005;
        
        % Mole fraction in Feed 3
        % y_c1 = y_a1 + y_b1
        y_c1 = 0.510;
        
        %% Constants
        % Ideal gas constant
        R = 8.314;
        % Temperature
        T = 373;
        % Total volume of system
        V = 122;
        % Liquid molar density
        p_L = 8.3;
        
        % Maximum feed flows
        F_1_max = 330.46;
        F_2_max = 22.46;
        
        % Constants for molar rates of flows
        C_v3 = 0.00352;
        C_v4 = 0.0417;
        
        % Valve time constant
        t_v = 10/3600;
        
        % Nominal gain of controller
        K_c = -1.4;
        
        % Constant for the assumed isothermal operation
        k_0 = 0.00117;
        
        %% Summing variables
        sum_X_4;
        bar_X_4;
        
        trials;
    end
    
    methods
        %% Constructor
        function obj = SimpleTE()
            % Initialize nominal values
            obj.nom_N_a = 44.49999958429348;
            obj.nom_N_b = 13.53296996509594;
            obj.nom_N_c = 36.64788062995841;
            obj.nom_N_d = 110.0;
            obj.nom_X_1 = 60.95327313484253;
            obj.nom_X_2 = 25.02232231706676;
            obj.nom_X_3 = 39.25777017606444;
            obj.nom_X_4 = 47.03024823457651;
            obj.nom_u_1 = 60.95327313484253;
            obj.nom_u_2 = 25.02232231706676;
            obj.nom_u_3 = 39.25777017606444;
            obj.nom_u_4 = 44.17670682730923;
            obj.nom_F_1 = 201.43;
            obj.nom_F_2 = 5.62;
            obj.nom_F_3 = 7.05;
            obj.nom_F_4 = 100.00;
            obj.nom_P = 2700.00;
            obj.nom_V_L = 44.18;
            obj.nom_y_a3 = 47.00;
            obj.nom_y_b3 = 14.29;
            obj.nom_y_c3 = 38.71;
            obj.nom_C = 0.2415;
            
            
            % Initialize state
            obj.N_a = obj.nom_N_a;
            obj.N_b = obj.nom_N_b;
            obj.N_c = obj.nom_N_c;
            obj.N_d = obj.nom_N_d;
            obj.X_1 = obj.nom_X_1;
            obj.X_2 = obj.nom_X_2;
            obj.X_3 = obj.nom_X_3;
            obj.X_4 = obj.nom_X_4;
            
            % Initialize inputs
            obj.u_1 = 100;
            obj.u_2 = 0;
            obj.u_3 = 0;
            obj.u_4 = 100;
            %obj.u_1 = obj.nom_u_1;
            %obj.u_2 = obj.nom_u_2;
            %obj.u_3 = obj.nom_u_3;
            %obj.u_4 = obj.nom_u_4;
            
            % Initialize outputs
            obj.F_1  = obj.nom_F_1;
            obj.F_2  = obj.nom_F_2;
            obj.F_3  = obj.nom_F_3;
            obj.F_4  = obj.nom_F_4;
            obj.P    = obj.nom_P;
            obj.V_L  = obj.nom_V_L;
            obj.y_a3 = obj.nom_y_a3;
            obj.y_b3 = obj.nom_y_b3;
            obj.y_c3 = obj.nom_y_c3;
            obj.C    = obj.nom_C;
          
            % Initialize bar_X_4
            obj.sum_X_4 = obj.nom_X_4;
            obj.trials = 1;
            obj.bar_X_4 = obj.sum_X_4 / obj.trials;
  
        end
        
        %% Accessor functions
        function[ y ] = getOutputs(obj)
            y = [obj.F_1, obj.F_2, obj.F_3, obj.F_4, obj.P, obj.V_L, obj.y_a3, obj.y_b3, obj.y_c3, obj.C];
        end
        
        function [ u ] = getNomInputs(obj)
            u = [obj.nom_u_1, obj.nom_u_2, obj.nom_u_3, obj.nom_u_4];
        end
        function [ x ] = getNomState(obj)
            x = [obj.nom_N_a, obj.nom_N_b, obj.nom_N_c, obj.nom_N_d, obj.nom_X_1, obj.nom_X_2, obj.nom_X_3, obj.nom_X_4];
        end
        function [ y ] = getNomOutputs(obj)
            y = [obj.nom_F_1, obj.nom_F_2, obj.nom_F_3, obj.nom_F_4, obj.nom_P, obj.nom_V_L, obj.nom_y_a3, obj.nom_y_b3, obj.nom_y_c3, obj.nom_C];
        end
        
        
        function [ x ] = getState(obj)
            x = [obj.N_a, obj.N_b, obj.N_c, obj.N_d, obj.X_1, obj.X_2, obj.X_3, obj.X_4];
        end
        
        function [ u ] = getLastInputs(obj)
            u = [obj.u_1, obj.u_2, obj.u_3, obj.u_4];
        end
        

        
        %% Run an interation of tennesee eastman
        function [ new_obj ] = runIteration( obj, u, dt)
            % Convert inputs to something useful
            obj.u_1 = u(1);
            obj.u_2 = u(2);
            obj.u_3 = u(3);
            obj.u_4 = u(4);
            
            % Total Molar holdup
            % N = N_a + N_b + N_c
            N = obj.N_a + obj.N_b + obj.N_c;
            
            % Purge amounts
            % y_n3 = N_n / N
            obj.y_a3 = obj.N_a / N;
            obj.y_b3 = obj.N_b / N;
            obj.y_c3 = obj.N_c / N;

            % Liquid inventory (volume of liquid)
            % V_L = N_d / p_L
            obj.V_L = obj.N_d / obj.p_L;

            % Volume of vapor
            % V_v = V - V_L
            V_v = obj.V - obj.V_L;
            
            % Ideal gas law (get pressure of system)
            % P = N * R * T / V_v
            obj.P = N .* obj.R .* obj.T / V_v;

            % Pressures of given parts
            % P_n = y_n3 * P
            P_a = obj.y_a3 .* obj.P;
            P_b = obj.y_b3 .* obj.P;
            P_c = obj.y_c3 .* obj.P;

            % Production rate of D
            % R_d = k_0 * (P_a ^ 1.2) * (P_c ^ 0.4)
            R_d = obj.k_0 .* (P_a .^ 1.2) .* (P_c .^ 0.4);

            % Feed flow measurements
            % F_n_max * (X_n / 100)
            obj.F_1 = obj.F_1_max .* (obj.X_1/100);
            obj.F_2 = obj.F_2_max .* (obj.X_2/100);

            % Purge flow measurement
            % (X_3 / 100) * C_v4 * sqrt(P - 100)
            obj.F_3 = (obj.X_3/100) .* obj.C_v3 .* sqrt(obj.P - 100);

            % Product flow measurement
            % (X_4 / 100) * C_v4 * sqrt(P - 100)
            obj.F_4 = (obj.X_4/100) .* obj.C_v4 .* sqrt(obj.P - 100);

            % Instantaneous operating cost
            % (F_3 / F_4) * (2.206 * y_a3 + 6.177 * y_c3)
            obj.C = (obj.F_3 / obj.F_4) .* (2.206 .* obj.y_a3 + 6.177 .* obj.y_c3);

            %% FIXME use real derivatives
            % Update N_a-d state
            % dN_a = (y_a1 * F_1) + F_2 - (y_a3 * F_3) - R_d
            % dN_b = (y_b1 * F_1) - (y_b3 * F_3)
            % dN_c = (y_c1 * F_1) - (y_c3 * F_3) - R_d
            % dN_d = R_d - F_4
            dN_a = obj.y_a1 .* obj.F_1 + obj.F_2 - obj.y_a3 * obj.F_3 - R_d;
            dN_b = obj.y_b1 .* obj.F_1 - obj.y_b3 .* obj.F_3;
            dN_c = obj.y_c1 .* obj.F_1 - obj.y_c3 .* obj.F_3 - R_d;
            dN_d = R_d - obj.F_4;

            
            N_a_new = obj.N_a + dN_a * dt;
            N_b_new = obj.N_b + dN_b * dt;
            N_c_new = obj.N_c + dN_c * dt;
            N_d_new = obj.N_d + dN_d * dt;

            %% FIXME Use real derivatives
            % Update x_i state
            % For 1-3
            % t_v(dx_i/dt) + x_i - u_i = 0
            dX_1 = ((obj.u_1 - obj.X_1) / obj.t_v);
            dX_2 = ((obj.u_2 - obj.X_2) / obj.t_v);
            dX_3 = ((obj.u_3 - obj.X_3) / obj.t_v);


            X_1_new = obj.X_1 + dX_1 * dt;
            X_2_new = obj.X_2 + dX_2 * dt;
            X_3_new = obj.X_3 + dX_3 * dt;

            % For 4
            % t_v (dx_4/dt)+x_4 - [bar_x_4 + K_c(u_4-y_6) = 0

            dX_4 = ((obj.bar_X_4 + obj.K_c * (obj.u_4 - obj.V_L)) - obj.X_4) / obj.t_v;

            X_4_new = obj.X_4 + dX_4 * dt;
            
            obj.trials = obj.trials + 1;
            obj.sum_X_4 = obj.sum_X_4 + obj.X_4;
            obj.bar_X_4 = obj.sum_X_4 / obj.trials;
  
            %% Finish up state and outputs
            % Setup outputs
            y = [obj.F_1, obj.F_2, obj.F_3, obj.F_4, obj.P, obj.V_L, obj.y_a3, obj.y_b3, obj.y_c3, obj.C];
            y
            % Setup new state
            x_new = [N_a_new, N_b_new, N_c_new, N_d_new, X_1_new, X_2_new, X_3_new, X_4_new];
            
            obj.N_a = N_a_new;
            obj.N_b = N_b_new;
            obj.N_c = N_c_new;
            obj.N_d = N_d_new;
            obj.X_1 = X_1_new;
            obj.X_2 = X_2_new;
            obj.X_3 = X_3_new;
            obj.X_4 = X_4_new;
            new_obj = obj;
        end


    end
    
end

