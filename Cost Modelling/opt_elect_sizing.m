function [P_av, C_av, varargout] = opt_elect_sizing(D, eta_c, eta_d, J_P, J_C, iter)
%% This function solves an optimisation problem to find the minimal battery 
% and solar panel sizes.

% It does so by letting the energy inside the batteries be a variable of
% the optimisation problem and solves for the minimal maximum value of the
% storage vector.

% See reference on linprog for details about the structure of the matrices
% that follow

%% Input arguments
% D is the daily aggregate demand in kWh 
% eta_c is the charging efficiency of the battery
% eta_d is the discharging efficiency of the battery
% J_P is the cost per kW nominal power of solar panels
% J_C is the cost per kWh nominal storage capacity of the battery

%% Output Arguments
% P_av is the nominal power of solar panels (average of all the simulations)
% C_av is the needed capacity of the battery in kWh (average of all the simulations)
% (optional) fail_rate is the expected number of days it will not operate in a year
% (optional) SS defined as the collection of all S[k] as below
% (optional) P all values calculated
% (optional) C all values calculated

%% Working variables
% S[k] is the energy inside the battery on day k
% DD is a vector containing the damand in kWh for each day of the year

%% Build cost function f
f = [J_P,J_C,zeros(1,365)]';

%% Calculate Ed and DD and initialize output
% Ed is a vector containing the ratio of energy per kW nominal power
% installed for each day in a year

Ed = Ed_dist(iter);
DD = ones(365,1).*D;

P = zeros(1,iter);
C = zeros(1,iter);
SS = zeros(365,iter);

%% Start big loop
% TODO: Think of way to not do the loop
for i = 1:iter
    
%% Build inequality constraints
% First constraint is -eta_c Ed[k] P - S[k] < -(1/eta_d)D[k], i.e. the
% demand must be less or equal to the total energy into the battery plus
% the energy already in the battery

A1 = [-eta_c.*Ed(:,i),zeros(365,1),-eye(365)];
b1 = -(1/eta_d)*DD;

% % Modified Constraints to allow demand management
% % Now demand has to be met on a 7 days aggregate
% T = [eye(359),zeros(359,6)]+[zeros(359,1),eye(359),zeros(359,5)]+...
%     [zeros(359,2),eye(359),zeros(359,4)]+[zeros(359,3),eye(359),zeros(359,3)]...
%     +[zeros(359,4),eye(359),zeros(359,2)]+[zeros(359,5),eye(359),zeros(359,1)]...
%     +[zeros(359,6),eye(359)];
% A1 = [-eta_c.*T*Ed(:,i),zeros(359,1),-T];
% b1 = -(1/eta_d)*7*DD(1:359);

% Second constraint is S[1]<S[365], i.e. the energy at the end of the year
% must be more or equal to the energy at the beginning of the year,
% otherwise we would accumulate a deficit each year.

A2 = [0,0,1,zeros(1,363),-1];
b2 = 0;

% Third Constraint is P > 0, C > 0, and S[k] > 0, i.e. nominal solar panel, 
% battery capacity and energy in the battery, cannot be less than 0
A3 = -eye(367);
b3 = zeros(367,1);

% Fourth Constraint is S[k]<C, necessary to ensure that max(S) is C
A4 = [zeros(365,1),-1.*ones(365,1),eye(365)];
b4 = zeros(365,1);

% Combine Constraints into single matrices
A = [A1;A2;A3;A4];
b = [b1;b2;b3;b4];

%% Build Equality Constraint
% The equality constraint is set to ensure no energy is created or lost by
% the system, i.e. S[k] = S[k-1] + eta_c Ed[k-1] P - (1/eta_d)D

% Crop Ed to 364 elements
Ed_tilda = Ed(1:364,i);

% M is defined as (-1 1 0 0 ... 0 0)  (364 * 365) matrix
%                 ( 0-1 1 0 ... 0 0)
%                 ( 0 0-1 1 ... 0 0)
%                       ...
%                 ( 0 0     ...-1 1)
M = [zeros(364,1),eye(364)]-[eye(364),zeros(364,1)];

% Complete the equations
Aeq= [-eta_c.*Ed_tilda,zeros(364,1),M];
beq= -(1/eta_d).*DD(1:364);

%% Find optimal solution
x = linprog(f,A,b,Aeq,beq); 

% Extract Parameters of interest
P(i) = x(1);
C(i) = x(2);
SS(:,i) = x(3:end);

% Check simulation corresponds to optimisation
[~,SS_check] = sim_year(P(i),C(i),D,eta_c,eta_d,Ed(:,i),SS(1,i));

if norm(SS(:,i)-SS_check)>10^-5
    warning ('Simulation not equal to optimisation result: N?%d',i);
end

%% End of big loop
end

%% Extract output parameters
P_av = mean(P);
C_av = mean(C);

%% Calculate the number of days of failure
fail_tot = 0;
for i = 1:iter
    [fail_days,~] = sim_year(P_av,C_av,D,eta_c,eta_d,Ed(:,i),SS(1,i));
    
    fail_tot = fail_tot + fail_days;
end

fail_rate = fail_tot/iter;

% Check optional additional outputs
if nargout > 2
    varargout{1} = fail_rate;
    if nargout > 3
        varargout{2} = SS;
        if nargout > 4
            varargout{3} = P;
            if nargout > 5
                varargout{4} = C;
                if nargout > 6
                    varargout{5} = Ed;
                end
            end
        end
    end
end


end

