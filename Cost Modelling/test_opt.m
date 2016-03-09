% Testing the optimisation function

% Define parameters for the estimation
E_cycle = 1.6;          % kWh per cycle
D = 1*30* E_cycle;      % Demand
eta_c = 0.7;            % Efficiency charging
eta_d = 0.8;            % Efficiency discharging
J_P = 840;              % Cost per kW nominal power
J_C = 367;              % Cost per kWh nominal capacity


[P, C, fail_rate] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C);
