% Rainfall Modelling
clear 
clc
close all

% Parameters of simulation
litersperwash = 60;
washesperday = 6;
wasterate = 0.5;


% Load Primary rainfall data
load('/Users/Leonardo/Documents/GitHub/WashingMachineProject/Rainfall/rainfall_data.mat');
days = [31 28 31 30 31 30 31 31 30 31 30 31]';
% Compute monthly average
rainfall = (Burundi + Rwanda)/2; % l/m^2 per month

% Compute monthly water demand
demand = wasterate.*(litersperwash.*washesperday).*days; % l per month

% Compute demand for minimum roof size and storage
av_dailyrainfall = mean(rainfall./days); % l/m^2 per day
min_roof = litersperwash.*washesperday./av_dailyrainfall; % m^2
storagepermonth = rainfall.*min_roof-demand;
min_storage = max(storagepermonth);
plot(storagepermonth);
