function [Angle] = best_angle(Elev)
%% This function solves an optimisation problem to find the optimal solar 
% panel angle wrt the ground, given a solar elevation angle for each hour 
% and month (degrees) and a Monthly Averaged Daylight Cloud Amount (%)

%% Calculating the power reaching the panel for each hour of the day and month 

% Power reaching earth for each hour and month, starting from a value of 
% 1.365 kW/m2 at the TOA and taking into account the loss due to the 
% atmosphere thickness, AM (semi-empirical model) (kW)
P_earth = 1.365*(0.7).^((1./sin(Elev*2*pi/360)).^0.678);

% Value to be maximised: Power reaching directly a horizontal surface 
% on earth for each hour and month (kW)
% P_direct = P_earth.*sin((Elev*2*pi/360)+Angle);

%% Loop
for i = 1:12
    
    %% Build constraints

    % Dummy constraint for inequality and equality
    A=zeros(1,11);
    b=ones(1,11);
    Aeq=zeros(11,1);
    beq=zeros(11,1);

    % Constraints for range
    lb = sin(Elev(i,:)*2*pi/360);
    ub = sin(pi/2+Elev(i,:)*2*pi/360);

    %% Optimize x for maximum power output
    x = linprog(-P_earth(i,:),A,b,Aeq,beq,lb,ub);

    % Find angle in radians
    Angle(i) = asin(x)-Elev(i,:)*2*pi/360

end
