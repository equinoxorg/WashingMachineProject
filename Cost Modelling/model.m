% Model
clear

% Plot cost per cycle vs cycles per week
Q = (0:5:100)';
P = cycle2price(Q);

plot (Q,P,'r');
xlabel('Cycles per Week')
ylabel('Price per Cycle')