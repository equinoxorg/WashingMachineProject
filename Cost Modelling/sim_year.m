function [fail_days,SS] = sim_year(P,C,D,eta_c,eta_d,Ed,S0)
% Simulates the bettery profile given the inputs given, returns the status 
% the battery for each day and the number of days the system fails

% Initialise variables
SS = zeros(365,1);
fail_days = 0;

% Set starting value of battery charge
SS(1) = S0;

for i = 2:365
   SS(i) = eta_c.*Ed(i-1).*P + SS(i-1) - (1/eta_d).*D;
   
   if (SS(i) > C)
       SS(i) = C;
   elseif (SS(i) < 0)
       fail_days = fail_days + 1; 
       SS(i) = 0;
   end
end

end

