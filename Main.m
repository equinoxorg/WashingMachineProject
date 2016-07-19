% Model Test

% Define parameters for the estimation
E_cycle = 0.3;              % kWh per cycle
cycles_day = 10;            % Cycles per day
liters_wash = 50;           % Number of litres per wash
waste_rate = 0.5;           % Water recycle rate

D = cycles_day * E_cycle;   % Demand
eta_c = 0.7;                % Efficiency charging
eta_d = 0.8;                % Efficiency discharging
J_P = 830/15;               % $ Cost per kW nominal power / years lifetime
J_C = 167/3;                % $ Cost per kWh nominal capacity / years lifetime
iter = 10;                  % Number of years simulated

% Calculate electrical side needs
[P, C, fail_rate, SS,~,~,Ed] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter);
cycles_year = cycles_day*365;
cost_cycle = (P*J_P + C*J_C)/cycles_year;
cost_cycle_P = P*J_P/cycles_year;
cost_cycle_C = C*J_C/cycles_year;
batt_days = C/D;

disp(P);
disp(C);
disp(cost_cycle);

% Calculate water side needs
% Load Primary rainfall data
load('/Users/Leonardo/Documents/GitHub/WashingMachineProject/Rainfall/rainfall_data.mat');
days = [31 28 31 30 31 30 31 31 30 31 30 31]';
% Compute monthly average
weight = 1;
rainfall = (weight.*Burundi + (1-weight).*Rwanda); % l/m^2 per month

% Compute monthly water demand
demand = (liters_wash.*cycles_day).*days; % l per month

% Compute demand for minimum roof size and storage
av_dailyrainfall = mean(rainfall./days); % l/m^2 per day
min_roof = waste_rate.*liters_wash.*cycles_day./av_dailyrainfall; % m^2
storage_month = demand - rainfall.*min_roof;
min_storage = max(storage_month);
plot(storage_month)

