% Testing the optimisation function
clear
close all;

% Define parameters for the estimation
E_cycle = 1.6;              % kWh per cycle
cycles_day = 10;            % Cycles per day
D = cycles_day * E_cycle;   % Demand
eta_c = 0.7;                % Efficiency charging
eta_d = 0.8;                % Efficiency discharging
J_P = 830/15;               % $ Cost per kW nominal power / years lifetime
J_C = 167/3;                % $ Cost per kWh nominal capacity / years lifetime
iter = 1;                  % Number of years simulated

figure; 

[P, C, fail_rate, SS,~,~,Ed] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter);
%plot(SS); hold on
%plot(ones(365,1).*(1/eta_d).*D); hold on 
%plot(eta_c.*Ed.*P); hold on
%plot(eta_c.*Ed.*P - ones(365,1).*(1/eta_d).*D); hold on
plot(cumsum(eta_c.*Ed.*P - ones(365,1).*(1/eta_d).*D),'r'); hold on
plot(cumsum(smooth(eta_c.*Ed.*P - ones(365,1).*(1/eta_d).*D,14)),'b'); hold on

cycles_year = cycles_day*365;
cost_cycle = (P*J_P + C*J_C)/cycles_year;
cost_cycle_P = P*J_P/cycles_year;
cost_cycle_C = C*J_C/cycles_year;
batt_days = C/D;
