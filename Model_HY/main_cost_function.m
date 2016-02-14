function [ main_cost_function ] = main_cost_function(T_l,Q_s)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%T_l=Laundry Period, defined as (Washing Machine Load)/(HH Daily Laundry
%Production)

%Q_s=Quantity Supplied

%total_cost is a function of laundry period and quantity supplied)
%Can be defined to use other independent variables

global Q_s
global T_l

Q_s=1;

WM_load=10;
LP_hh=2.5;

T_l=WM_load/LP_hh;

main_cost_function=total_cost_T_l(T_l,Q_s)/Q_s;

%plot(Q_s,installation_costs_per_day);

end

