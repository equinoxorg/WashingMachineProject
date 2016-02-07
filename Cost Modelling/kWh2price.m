function [P] = kWh2price(E)
% E is the kWh per week consumed (note this may be a vector)
% P is the price per week expected ($/week) (note this may be a vector)

%% First estimate the cost associated with the solar panels installation
kW_inst = kWh2kW (E);   % Estimates the kW required 
P = kW2price (kW_inst); % Estimate cost of installation/lifetime



end

