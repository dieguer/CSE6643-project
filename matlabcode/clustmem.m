%This function takes the H matrix in the algorithm and 
% returns the vector X which indicates the cluster to which each 
% unit belongs 

function S= clustmem(X)
    
    [m,n]=size(X);
    S=zeros(n,1);
    for i=1:n
        [h,j]=max(X(1:m,i));
        


        if h==0
         j=99;   
        end
        
        S(i)=j;
     end    
    end

