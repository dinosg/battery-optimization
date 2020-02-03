function [ mK ] = fillhmat( K, h0 )
%make a matrix that adjusts matrix K by efficiency h0
sK=size(K);
th=sK(2);  %this is the 'time horizon', 2nd dimension of argument matrix
mK=-K;  %now do the part where the current factors into the ramp limitation constraint
%but efficiency works different ways depending on whether discharging (odd
%cases) or charging (even cases)
%the argument already has both cases for the absolute values (+ and -)
%hence double #rows -2
for zz=2:2:2*th-2
    mK(zz,:)=mK(zz,:)/(.5*(1+h0));
    mK(zz-1,:)=mK(zz-1,:)*(.5*(1+h0));
end

end

