%% Model Test

%% Define parameters for the estimation
E_cycle = 0.25;             % kWh per cycle
cycles_day = 10;            % Cycles per day
liters_wash = 60;           % Number of litres per wash
waste_rate = 0.4;           % Water wasted for each cycle rate
eta_c = 0.7;                % Efficiency charging
eta_d = 0.8;                % Efficiency discharging
J_P = 830/15;               % $ Cost per kW nominal power / years lifetime
J_C = 167/3;                % $ Cost per kWh nominal capacity / years lifetime
iter = 10;                  % Number of years simulated
eta_pump = 0.6;             % Pump efficiency

%% Calculate water side needs
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

%% Electrical Energy Demand per day
D = cycles_day * E_cycle;               % Cycle electricity

% Pumping energy requirements
vol_day1 = av_dailyrainfall*min_roof*1.5;   % Volume of rainwater per day
vol_day2 = liters_wash * cycles_day;        % Volume of water per day
pres1 = 1.5;                                % Pressure difference for rainwater pump
pres2 = 2.5;                                % Pressure difference for membrane pump
pump1_kWh = 1e-3*(vol_day1/eta_pump)*pres1;
pump2_kWh = 1e-3*(vol_day2/eta_pump)*pres2;
D = D + pump1_kWh + pump2_kWh;              % Pumping requirements added

% Calculate electrical side needs
[P, C, fail_rate, SS,~,~,Ed] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter);
cycles_year = cycles_day*365;
C = C*2;
cost_cycle = (P*J_P + C*J_C)/cycles_year;
cost_cycle_P = P*J_P/cycles_year;
cost_cycle_C = C*J_C/cycles_year;
batt_days = C/D;

disp(P);
disp(C);
disp(cost_cycle);


