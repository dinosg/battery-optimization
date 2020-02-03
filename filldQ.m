function [ dQ ] = filldQ( th )
%this function creates the dQ matrix. Q' = dQ * Q, ie calculates the dQ's
%th is the time horizon
dQ=zeros(th-1,th);
for j=1:th-1
   
    
    dQ(j,j+1) = 1;
    dQ(j,j)= -1;
 
  
end

