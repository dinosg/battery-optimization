function [ netrevenue ] = batfunc_anon( x, Price1, fcast1, qmax1, bat_pow_scale, bat_charge_mean )


  %fcast is a row vector, x is a col vector - 
%contaning the inverter the control function (th =time horizon points)
% and the state of charge q (= th, timehorizon points)
% need to make it negative because function minimizes, not maximizes
th=length(x)/2;  %get the time horizon

q=x(th+1:end); %extract state of charge
%now create matricies for computing charging power
M=fillM(q);
netrevenue = -Price1*fcast1*x(1:th)+(q'-qmax1*bat_charge_mean)*...
    (q-qmax1*bat_charge_mean)*bat_pow_scale ;
%netrevenue = -Price1*fcast1*x(1:th) + sum(Price1*M*q) - q'*q;
%000; 
%netrevenue = -Price1*fcast1*x(1:th) + Price1*M*q - 0.001*q'*q;

end

