
scale_factor=2;   %adjust everything by this
%assume forecast & data have been interpolated for 30 sec intervals
bat_currentmax = 0.3;  %battery is 30% of PV nameplate
th=12; %forecast ahead 9 - 3= 6 time steps 
Price=50;
h0=.9; %round trip battery efficiency
lf=260; % #of time points to iterate through
data_archive=zeros(lf,2);
error_state = zeros(lf);

%f is the production curve - given for now but to be forecasted

kleissl=xlsread('march3.xls', 'avg');
f0=max(kleissl(:,1)); %normalized to max f, approximately    
Currentmax = f0*bat_currentmax/scale_factor; %set max current at % total power for now
qmin=0;
qmax = Currentmax*10; % try max charge = time units of current carrying capacity
rr_requirement=0.05/scale_factor; %set ramp rate limit = 7.5% for scale_factor=2
inverter_min=0.;  %set min inverter levels
q_init=qmax*.75; %start with battery 75%
q_init1 = q_init;
q_init2 = q_init;
x_init = 1; %start with inverter at 100%


bat_pow_scale = 0.0002;
bat_charge_mean= 0.75;

timehorizon=1:th;
futurehorizon = [1 1 1:(th-2)];% present = futurehorizon=1
f=kleissl(:,1);
sk=size(kleissl);  % size of matrix containing current data and all forecasts
for tp=1:lf-th-1
   
    timehorizon=tp:(th+tp-1);
    linearind=sub2ind(sk,timehorizon,futurehorizon);linearind=sub2ind(sk,timehorizon, futurehorizon);

    fcast=kleissl(linearind); %extract the actual forecast from 1 to th-2

    
    [xres, fval, xflag] = PV_optim(fcast, Price, qmax, qmin, f0, Currentmax, th, rr_requirement,...
    q_init1, q_init2, x_init, h0, inverter_min, bat_pow_scale, bat_charge_mean);

    x01=xres(1:th,1); %extract inverter part of solution 
    x02=xres(1:th,2); %extract battery state of charge part of solution
    
    
%   archive x01, x02 values in some matrix
%
%
%
    data_archive(tp,1)=x01(1);
    data_archive(tp,2)=x02(1);
    error_state(tp)= xflag;
%   iterate, but first reset x_init, q_init's
    x01=circshift(x01,-1);
    x01(th)=x01(th-1);
    x_init = x01(1);
    x02=circshift(x02,-1);
    x02(th)=x02(th-1);
    q_init1=x02(1);
    q_init2=x02(2);
    x0 = [x01 ; x02];
   
end

