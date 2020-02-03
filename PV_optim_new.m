function [xresult, fval, xflag ] = PV_optim(fcast, Price, qmax, qmin, f0, Currentmax, th, rr_requirement, q_init1, ...
q_init2, x_init, h0, inverter_min, bps, bcm)
%v4
%this version uses 1st 3 time points from past & present before looking at predictions
%
%args:  
% fcast = power production forecast
%Price = power price
%qmax = battery charge max in units of power-minutes
%qmin = batter charge min
%f0 = maximum nameplate power
%Currentmax = max current (in PV power units)
%th = time horizon, eg. # minutes forecast
%scale_factor = #forecast data points/minute (eg. in forecast time series,
%2 datapoints per minute means scale_factor = 2)
%rr_requirement = PV ramp max requirement, all ramps must be below this.
%is in % of f0
%q_init is initial charge
%x_init is  inverter throughput
%h0 is battery round-trip efficiency
%inverter_min is minimum inverter throughput, eg. set = 1 to only use
%battery to smooth ramps

%xresult is a 2-d array (th,2) containing the best fit inverter throughput
%and battery charge, projected th time units into the future.
%fval is a code showing the success of the fitting routine.global Price
global Price1
global qmax1
global fcast1  %these have to be global to pass indirectly to cost
global bat_pow_scale
global bat_charge_mean
bat_pow_scale = bps;
bat_charge_mean = bcm;
%function through fmincon.
Price1 = Price; %keep annoying message about global variables away
fcast1 = fcast;
qmax1=qmax;
batfunc=@(x)batfunc_anon( x, Price, fcast, qmax, bps, bcm );
%set equality constraints (ensuring that the 1st time point 
%is NOT fit but stays the same):
Aeq=zeros(th*2);
Aeq(1,1)=1;
Aeq(th+1,th+1)=1;
Aeq(th+2,th+2)=1;  %keep charge fixed 2 points out...
beq=zeros(2*th,1);

 
beq(1,1)=x_init;  %set these guys for now
beq(th+1,1)=q_init1;  %to start out with....
beq(th+2,1)=q_init2;  %to start out with....
%set initial conditions
x0 = ones(2*th,1);
xresult=ones(th,2);
x0(1)= x_init; %fix initial value of inverter throughput to current value
x0(th+1)=q_init1;
x0(th+2:end)=q_init2;
%set inequality
b=ones(2*(2*th-2),1)*rr_requirement*f0; % set initial conditions
b(2*th-1:end,1)=Currentmax;   %but fix last 1/2 of b to constrain current
A=-fillA(fcast); %create inequality constraint, backwards from inv only case!
N=fillN(th);
dQ=filldQ(th);
NdQ=N*dQ;
Abig=zeros(2*(2*th-2),2*th);
Abig(1:2*th-2,1:th)=A;
Abig(2*th-1:end,th+1:end)=NdQ;
hNdQ=fillhmat(NdQ,h0);  %now do the part where the current factors into the ramp limitation constraint
%but efficiency works different ways depending on whether discharging (odd
%cases) or charging (even cases)
ddQ=dQ(1:th-2,1:th-1)*dQ; %double derivative matrix for charge, ie. finds change in current flow
dN=N(1:2*th-4,1:th-2);  %set up 2x absolute value cases (+ and -) for double derivative
dNddQ=dN*ddQ;
%hdNddQ=fillhmat(dNddQ,h0);  %adjust for efficiency
k1=zeros(1,th);
dNddQ=[dNddQ ; k1 ;k1];
Abig(1:2*th-2,th+1:end)=-dNddQ ; %create 2nd derivative impact on ramp condition - affected by *change* in current flow
%Abig(1:2*th-2,th+1:end)=hNdQ;
%set upper and lower bound constraints:
lb=zeros(2*th,1) + inverter_min; %set lb for this = 0
ub=ones(2*th,1); 
lb(th+1:end,1)=qmin; %set statex0 of charge minimum piece
ub(th+1:end,1) = qmax; %set state of charge max piece
%set more of the arguments for fmincon
options=optimset('Algorithm', 'sqp', 'Display','off');
[x,fval,xflag]=fmincon(@batfunc1,x0,Abig, b, Aeq, beq, lb, ub, [], options); %find the optimal val of x!!
xresult(1:th,1)=x(1:th);
xresult(1:th,2)=x(th+1:end);
end

