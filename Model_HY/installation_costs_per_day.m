function [ installation_costs_per_day ] = installation_costs_per_day(Q_s)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

%Define i_th row (max= number of installation types) as particular installations
%Define j_th column (max= 3?) as fixed installation cost per unit, quantity
%of units and lifetime (in days)
%Define k_th 'page' (max= number of proposals) as different proposals.
%Different proposals are made in accordance to threshold Q_s values, producing the
%discontinuous curve

global Q_s
global T_l

Q_s=1;

WM_load=10;
LP_hh=2.5;

T_l=WM_load/LP_hh;

%1st Proposal
A(:,:,1)=[
    1000 2 500; %1st element
    2000 5 600; %2nd element
    ];

%2nd Proposal
A(:,:,2)=[
    1500 3 750; %1st element
    2000 5 600; %2nd element
    ];

%Quantity to supply

if Q_s<=5
    k=1;
end
    
if Q_s>5 && Q_s<=20
    k=2;
end
    
if Q_s>20 && Q_s<=50
    k=3;
end

%C defined as cost per day for a particular installation
C=[];

size_array=size(A(:,1,1));

for x=1:size_array(1)
    C=[C,(A(x,1,k)*A(x,2,k)/A(x,3,k))];
end

installation_costs_per_day=sum(C);

