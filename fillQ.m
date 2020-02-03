function [ Qconst ] = fillQ( th )
%this function creates the inequality constraint matrix for optimizing the
%transfer function eta, with the time forecast vector

Qconst=zeros(2*th,th);
for j=1:th
    p2=2*j;
    p1=2*j-1;
    
    Qconst(p2,j+1) = -1;
    Qconst(p1,j+1)= 1;
 
    

end

