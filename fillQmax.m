function [ Qconst ] = fillQmax( th )
%this function creates the inequality constraint matrix for  the
%state of charge,  
%th is the time horizon

Qconst=zeros(2*th,th);
for j=1:th
    p2=2*j;
    p1=2*j-1;
    
    Qconst(p2,j) = -1;
    Qconst(p1,j)= 1;
 
    

end

