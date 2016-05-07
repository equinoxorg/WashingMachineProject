function [Angle] = best_angle2(Elev)
%% This function solves an optimisation problem to find the optimal solar 
% panel angle wrt the ground, given a solar elevation angle for each hour 
% and month (degrees) and a Monthly Averaged Daylight Cloud Amount (%)

%% Calculating the power reaching the panel for each hour of the day and month 

% Power reaching earth for each hour and month, starting from a value of 
% 1.365 kW/m2 at the TOA and taking into account the loss due to the 
% atmosphere thickness, AM (semi-empirical model) (kW)
P_earth = 1.365*(0.7).^((1./sin(Elev*2*pi/360)).^0.678);

% Power reaching directly a horizontal surface on earth
% for each hour and month (kW/m^2)
% P_direct = P_earth.*sin(Elev*2*pi/360);

% Creating a matrix with dimensions equivalent to P_earth and P_direct
Cloud = Cloud_vec(1:12)*ones(1,11);

% Power reaching a solar panel for each hour and month, taking into 
% consideration the effects of clouds (kW/m^2)
% P_panel = (1-Cloud).*(P_earth*0.1+P_direct)+Cloud.*(0.2*P_earth);

%% Extracting Energy informations from the Power distribution matrix

% Average daily energy available for each month (kWh/m^2)
% E_month = sum(P_panel,2);

% Days in a month
days = [31 28 31 30 31 30 31 31 30 31 30 31;]; 

    
    %% Build constraints

    %% Optimize x for maximum power output
    x = linprog(-days,A,b,Aeq,beq,lb,ub);

    % Find angle in radians
    Angle = 


