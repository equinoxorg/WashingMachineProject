function [P] = cycle2price( Q )
% This function takes as an input the number of cycles per week and returns
% an expected price per cycle calculated as the sum of the running costs and the
% installation costs divided by the lifetime of the installation

% Q = cycles/week (note this may be a vector)
% P = $/cycle (note this may be a vector)

%% Calculate price due to electricity consumption
% Convert into kWh per week
% ASSUMPTION: 1 cycle consumes 1.6 kWh (from EU A standard 60?C)
E_cycle = 1.6;      % kWh per cycle
E = Q .* E_cycle;    % kWh per week

% Include efficiency of inverter
E = E./0.5; % ASSUMPTION: inverter efficiency is 80% confirmation needed

load_size= 8; %Laundry capacity of washing machine in kg
V_cycle= 10*load_size; %L per cycle, considers water cons. per kg of laundry (=10)
V= Q .* V_cycle; %L per week



% Convert noting that the function returns ($/week)
P = kWh2price(E)./Q + % $/cycle due to the enrgy consumption
     L2price(V)./Q + % $/cycle due to water consumption
     Wash_N2price(Wash_N) + %$/cycle due to number of washing machines installed
     Q_Misc2price(P) + %Miscellaneous quantity-based costs, scale independent for example laundry detergent supply
     T_Misc2price(P) + %Miscellaneous time-based costs, scale independent for example construction costs
     ;
     
%% Round price to the nearest cent
P = round(P.*100)./100;
end


