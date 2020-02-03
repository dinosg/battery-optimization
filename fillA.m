function [ Aconst ] = fillA( f )
%this function creates the inequality constraint matrix for optimizing the
%transfer function eta, with the time forecast vector
L1 = length(f); %time horizon, ie. # of time points
Aconst=zeros(2*L1-2,L1);
for j=0:L1-2
    p1=2*j+1;
    p2=2*j;
    p3=2*j-1;
    p4=2*j-2;
    if(j< L1-2)
        Aconst(p1+1,j+1)=-f(j+1);
        Aconst(p2+1,j+1)= f(j+1);
    end
    if(j > 0)
        Aconst(p3+1,j+1) = f(j+1);
        Aconst(p4+1,j+1)= -f(j+1);
    end
    

end

