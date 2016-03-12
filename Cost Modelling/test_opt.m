% Testing the optimisation function
clear

% Define parameters for the estimation
E_cycle = 1.6;              % kWh per cycle
cycles_day = 20;            % Cycles per day
D = cycles_day * E_cycle;   % Demand
eta_c = 0.7;                % Efficiency charging
eta_d = 0.8;                % Efficiency discharging
J_P = 830/15;               % $ Cost per kW nominal power / years lifetime
J_C = 167/3;                % $ Cost per kWh nominal capacity / years lifetime
iter = 1;                  % Number of years simulated

figure(1); 
hold on;


[P, C, fail_rate, SS] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter);
plot(SS); hold on
plot(ones(365,1)*D)

cycles_year = cycles_day*365;
cost_cycle = (P*J_P + C*J_C)/cycles_year;
cost_cycle_P = P*J_P/cycles_year;
cost_cycle_C = C*J_C/cycles_year;
batt_days = C/D;
