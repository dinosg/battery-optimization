function [ bconst ] = fillbQmax( th,qmax, qmin )
%this function creates the inequality constraint resultant vector for the max and min
%battery charge, qmin and qmax

bconst=zeros(2*th);
for j=1:th
    p2=2*j;
    p1=2*j-1;
    
    bconst(p2,j) = -qmin;
    bconst(p1,j)= qmax;
 
    

end

