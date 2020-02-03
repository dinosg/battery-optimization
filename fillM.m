function [ Mconst ] = fillM( q )
%this function creates the matrix used 
% to evaluate the charge current impact on energy, using an asymmetrical 
%energy efficiency function, h. h0 = 90% for round trip on lith ion battery.
%assume h = h0 for q' < 0 (discharging) and = 1 for charging.
% 
th=length(q);
dQ=filldQ(th);  %make the dQ matrix
Mconst=zeros(th-1,th-1);
s=50; %let s be a big # so exp(s) is very big)
h0=0.9;   %set h0 (of course could be anything, this is a typical value)
qcur=dQ*q;  %obtain current vector from dQ and q;
 
M1=(h0+ ((1-h0)./(1+exp(-s*qcur)))); %vectorize
Mconst=(diag(M1)*dQ);



