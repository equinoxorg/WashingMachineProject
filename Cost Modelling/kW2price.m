function P = kW2price (kW_inst)
% kW_inst is the nominal power required to be installed (note this may be a vector)
% P is in $/week (note this may be a vector)

%% Estimate based on real examples
% ASSUMPTION: the cost per nominal kW is constant
av_P_KW = 840; % from exel SolarPanelComparison based on real examples ($)
av_lifetime = 15*52; % lifetime of a solar panel estimated to 15 years (weeks)
P = av_P_KW.*kW_inst./av_lifetime;

end

