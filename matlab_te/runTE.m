function [ y, x_new ] = runTE( x, u , t)

% Convert state to something useful
N_a = x(1);
N_b = x(2);
N_c = x(3);
N_d = x(4);
x_1 = x(5);
x_2 = x(6);
x_3 = x(7);
x_4 = x(8);

% Convert inputs to something useful
u_1 = u(1);
u_2 = u(2);
u_3 = u(3);
u_4 = u(4);

% Constants
N = N_a + N_b + N_c;
R = 8.314;
T = 373;
V = 122;
p_L = 8.3;
F_1_max = 330.46;
F_2_max = 22.46;
C_v3 = 0.00352;
C_v4 = 0.0417;
t_v = 10/3600;
K_c = -1.4;

% Purge amounts
y_a3 = N_a / N;
y_b3 = N_b / N;
y_c3 = N_c / N;

% Liquid inventory (volume of liquid)
V_L = N_d / p_L;

% Volume of vapor
V_v = V - V_L;

% Ideal gas law (get pressure of system)
P = N .* R .* T / V_v;

% Pressures of given parts
P_a = y_a3 .* P;
P_b = y_b3 .* P;
P_c = y_c3 .* P;

% Production rate of D
R_d = k_0 .* (P_a .^ 1.2) .* (P_c .^ 0.4);

% Feed flow measurements
F_1 = F_1_max .* (x_1/100);
F_2 = F_2_max .* (x_2/100);

% Purge flow measurement
F_3 = (x_3/100) .* C_v3 .* sqrt(P - 100);

% Product flow measurement
F_4 = (x_4/100) .* C_v4 .* sqrt(P - 100);

% Instantaneous operating cost
C = (F_3 / F_4) .* (2.206 .* y_a3 + 6.177 .* y_c3);

% Update N_a-d state
dN_a = y_a1 .* F_1 + F_2 - y_a3 * F_3 - R_d;
dN_b = y_b1 .* F_1 - y_b3 .* F_3;
dN_c = y_c1 .* F_1 - y_c3 .* F_3 - R_d;
dN_d = R_d - F4;

%FIXME
N_a_new = N_a + dN_a * dt;
N_b_new = N_b + dN_b * dt;
N_c_new = N_c + dN_c * dt;
N_d_new = N_d + dN_d * dt;

%FIXME
% Update x_i state
% For 1-3
% t_v(dx_i/dt) + x_i - u_i = 0
x_1_new = x_1;
x_2_new = x_2;
x_3_new = x_3;

% For 4
% t_v (dx_4/dt)+x_4 - [bar_x_4 + K_c(u_4-y_6) = 0
x_4_new = x_4;

% Setup outputs
y = [F_1, F_2, F_3, F_4, P, V_L, y_a3, y_b3, y_c3, C];

% Setup new state
x_new = [N_a_new, N_b_new, N_c_new, N_d_new, x_1_new, x_2_new, x_3_new, x_4_new];

end