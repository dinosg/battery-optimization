function [ Nconst ] = fillN( th )
%this function creates the inequality constraint matrix for optimizing the
%constraint on min and max Q', 
 %th is time horizon, ie. # of time points, 1 greater than # current time
 %points
Nconst=zeros(2*th-2,th-1);
for j=1:th-1
   
    p2=2*j;
    p1=2*j-1;
    Nconst(p2,j)=-1;
    Nconst(p1,j)=1;
    
    
    

end

