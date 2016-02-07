function kW = kWh2kW (E)
% Calculate the installation requirements from a given Energy demand
% E is the kWh per week (kWh/week) (note this may be a vector)
% kW is the nominal power installation required in kW (note this may be a vector)

%% Irradiation data from NASA for months going Jan to Dec (kWh/m2/day)
% (1:12)'= ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']
% Monthly average irradiaction on a horizontal surface (kWh/m2/day)
I = zeros(12,2);
I(:,1) = [4.98;5.32;5.09;4.88;4.67;5.01;5.44;5.49;5.37;4.91;4.63;4.74];
I(:,2) = (1:12)';

% Monthly minimum difference from average (%)
I_min = zeros(12,2);
I_min(:,1) = [-10; -13; -6; -11; -12; -9; -17; -19; -11; -16; -18; -10];
I_min(:,2) = (1:12)';

%% Calculate m^2 required to fulfill demand
% ASSUMPTION: assume irradiation is always minimum
I(:,1) = I(:,1).*(ones(12,1)-I_min(:,1)./100);

% Calculate kWh/(m^2*week)
I(:,1) = I(:,1).*7;

% Calculate m^2 required (use minimum in the year)
m2 = E./min(I(:,1));

%% Convert to actual power output using efficincy
% Note that the nominal power output is calculated using a 1kW/m2 25?C reference
efficiency = 0.1764; % from exel SolarPanelComparison based on real examples

% Nominal power per meter squared surface (kW/m^2)
NomPowerM2 = efficiency; 

kW = NomPowerM2.*m2;

end

