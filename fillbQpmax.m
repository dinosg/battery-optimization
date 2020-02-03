function [ bcurconst ] = fillbQpmax( th,maxcurrent )
%this function creates the inequality constraint resultant vector for the
%max battery current

bcurconst=zeros(2*th-2,1);
for j=1:th-1
    p2=2*j;
    p1=2*j-1;
    
    bcurconst(p2) = maxcurrent;
    bcurconst(p1)= maxcurrent;
 
    

end

