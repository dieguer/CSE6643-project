function [W,H]=clustering(X,S,k,maxitr,alpha,beta)
    [m,n]=size(X);
    [ns1,ns2]=size(S);
    % W size m * k
    % H size k * n
    % X size m * n 
    % S size n * n 
    H=rand(k,n);
    Hhat=rand(k,n);
    W=rand(m,k);
    Ik=diag(ones(k,1));
    for i=1:maxitr
        [ wt,Y,iter,success ] = nnlsm_activeset(H',X');
        W=wt';
        m1=[sqrt(alpha)*H';sqrt(beta)*Ik];
        m2=[sqrt(alpha)*S;sqrt(beta)*H];
        [ Hhat,Y,iter,success ] = nnlsm_activeset(m1,m2);
        m1=[W;sqrt(alpha)*Hhat';sqrt(beta)*Ik];
        m2=[X;sqrt(alpha)*S;sqrt(beta)*Hhat];
        [ H,Y,iter,success ] = nnlsm_activeset(m1,m2);
    end
    