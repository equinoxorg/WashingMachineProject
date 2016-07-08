% Model Test

% Define parameters for the estimation
E_cycle = 0.6;              % kWh per cycle
cycles_day = 10;            % Cycles per day
D = cycles_day * E_cycle;   % Demand
eta_c = 0.7;                % Efficiency charging
eta_d = 0.8;                % Efficiency discharging
J_P = 830/15;               % $ Cost per kW nominal power / years lifetime
J_C = 167/3;                % $ Cost per kWh nominal capacity / years lifetime
iter = 10;                  % Number of years simulated

% Calculate electrical side needs
figure; 
[P, C, fail_rate, SS,~,~,Ed] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter);
plot(SS);