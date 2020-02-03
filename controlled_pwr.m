function [ cpwr ] = controlled_pwr( f,x, h0 )
%returns the controlled power from the uncontrolled power, f, and
%x, a 2-d array where x(1,:) is the inverter control fn and x(2,:) is the
%state of charge for the battery. h0 is the battery efficiency on discharge
%(assume charging efficiency=1)
%
%   in this version, the control parameters x = (npts, 2) not the other way
%   
%   so need to figure the actual current from the charge and the net
%   throughput
% calculate current from charge

Jcur=calculate_J(x(:,2));
smallest_size = min([length(f), length(x)]);
cpwr(1)=x(1,1)*f(1);
for j=2:smallest_size
    if(Jcur(j)) < 0
        cpwr(j)=x(j,1)*f(j)-Jcur(j)*0.5*(1+h0);
    else cpwr(j)=x(j,1)*f(j)-Jcur(j)/(0.5*(1+h0));
    end
        
end
end

