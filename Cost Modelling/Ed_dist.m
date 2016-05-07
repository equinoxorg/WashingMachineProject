function [Ed] = Ed_dist(iter)
%% Simple Stochastic modelling for solar panel power
% Input: iter = number of years to be predicted
% Output: Ed = matrix containing the energy per square meter for each day
% of the year (rows), for the number of years predicted (columns)          
% in kWh/m^2

%% Data from NASA for months going Jan to Dec 
% Rows(1:12)'=['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']
% Columns(1:11)'=['0500GMT';'0600GMT';'0700GMT';'0800GMT';'0900GMT';'1000GMT';
%                 '1100GMT';'1200GMT';'1300GMT';'1400GMT';'1500GMT']

% Monthly Averaged Hourly Solar Angles Relative To The Horizon (degrees)
Elev = [12.7	26.7	40.4	53.5	65.0	71.4	67.7	57.2	44.4	30.8	16.9
11.9	26.5	41.1	55.5	69.2	79.4	74.6	61.6	47.4	32.9	18.3
13.1	28.0	43.0	58.0	73.0	88.0	76.9	61.9	46.9	31.9	16.9
14.5	29.2	43.8	58.0	71.0	77.9	70.6	57.5	43.3	28.8	14.1
14.5	28.4	42.0	54.6	64.8	68.8	63.5	52.7	39.9	26.2	12.2
13.1	26.6	39.6	51.5	60.8	64.6	60.5	51.0	39.0	26.0	12.5
11.9	25.6	38.9	51.4	61.5	66.4	62.9	53.3	41.1	27.9	14.2
13.1	27.5	41.7	55.4	67.5	73.8	68.6	56.9	43.3	29.1	14.7
16.2	31.1	46.0	60.9	75.3	84.4	72.7	58.1	43.2	28.3	13.4
18.9	33.7	48.5	63.2	77.2	82.7	70.3	55.8	41.0	26.2	11.4
18.9	33.0	46.9	60.1	70.9	73.6	65.3	52.9	39.2	25.2	11.0
16.6	30.3	43.6	56.0	65.9	69.3	63.5	52.6	39.9	26.5	12.7]

% Monthly Averaged Daylight Cloud Amount (%)
Cloud_vec = [71.5;69.6;75.2;75.2;69.1;51.8;43.7;54.3;67.5;75.7;76.5;72.4]/100;

%% Calculating the power reaching the panel for each hour of the day and month 

% Power reaching earth for each hour and month, starting from a value of 
% 1.365 kW/m2 at the TOA and taking into account the loss due to the 
% atmosphere thickness, AM (semi-empirical model) (kW/m^2)
P_earth = 1.365*(0.7).^((1./sin(Elev*2*pi/360)).^0.678);

% Power reaching directly a horizontal surface on earth
% for each hour and month (kW/m^2)
P_direct = P_earth.*sin(Elev*2*pi/360);

% Creating a matrix with dimensions equivalent to P_earth and P_direct
Cloud = Cloud_vec(1:12)*ones(1,11);

% Power reaching a solar panel for each hour and month, taking into 
% consideration the effects of clouds (kW/m^2)
P_panel = (1-Cloud).*(P_earth*0.1+P_direct)+Cloud.*(0.2*P_earth);

%% Extracting Energy informations from the Power distribution matrix

% Average daily energy available for each month (kWh/m^2)
E_month = sum(P_panel,2);

% Days in a month
days = [31 28 31 30 31 30 31 31 30 31 30 31;]; 

% Calculate the total Energy available in a year (kWh/m^2)
E_year = days*E_month;

%% Assigning a daily value of energy over the years of iteration, 
% with a random uncertainty 

% Daily minimum insolation available (%)
Min = [29.5 4.32 21.8 31.9 30.8 30.5 24.0 36.4 33.3 27.6 18.5 23.6];

% Daily maximum insolation available (%)
Max = [162	152	157	166	147	137	130	137	145	156	153	151];

% Calculating the sigma
sigma = (Max-Min)/200;

% Creating an energy matrix with entries for each day of each year
Ed = zeros(365,iter);
tot = 0;

% Loop over the 12 months of the year
for i = 1:12
    %Ed(tot+1:tot+days(i),:) = E_month(i)*(Max(i)-Min(i))/100*rand(days(i),iter)+Min(i)/100;
    Ed(tot+1:tot+days(i),:) = sigma(i)*randn(days(i),iter)+E_month(i);
    tot = tot + days(i);
end

% All energy values must be positive
Ed(Ed<0) = 0;

% Plot daily energy output
plot(Ed)

end

