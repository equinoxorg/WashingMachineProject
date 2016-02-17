function [ total_cost_T_l ] = total_cost_T_l( T_l,Q_s )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

%Copied variables
WM_load=10;
LP_hh=2.5;

T_l=WM_load/LP_hh;

%To define Q_s as a range for curve plotting

total_cost_T_l=(installation_costs_per_day*T_l)+(cost_per_load*Q_s);
%installation_costs_per_day- installation costs divided by lifetime in units of days: T_l in units of days
%cost_per_load- Cost required to wash one load of clothes- taking into
%account water, electricity, etc.

end
