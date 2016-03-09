function [Ed] = Ed_dist()
% Simplest of possible stochastic modelling for solar panel power

%% Irradiation data from NASA for months going Jan to Dec (kWh/m2/day)
% (1:12)'= ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']
% Monthly average irradiaction on a horizontal surface (kWh/m2/day)
I = [4.98;5.32;5.09;4.88;4.67;5.01;5.44;5.49;5.37;4.91;4.63;4.74];

% Monthly minimum difference from average (%)
I_min = [-10; -13; -6; -11; -12; -9; -17; -19; -11; -16; -18; -10];

% Create sigma using min variation
sigma = (-I_min/50).*I;
% Days in month
days = [31;28;31;30;31;30;31;31;30;31;30;31;]; 

%% Create Irradiation Vector
E = zeros(365,1);
tot = 0;

for i = 1:12
    E(tot+1:tot+days(i)) = I(i) + sigma(i)*randn(days(i),1);
    tot = tot + days(i);
end

% Ensure it is never lower than zero power
E(E<0) = 0;

%% Convert to actual power output using efficincy
% Note that the nominal power output is calculated using a 1kW/m2 25?C reference
efficiency = 0.1764; % kW/m^2

% kWh per unit Nominal power (kWh/(kW*day)) is given by
Ed = (1/efficiency).*E;

end

