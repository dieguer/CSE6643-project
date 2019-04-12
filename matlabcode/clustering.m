% implementation of paper 
%   "Hybrid clustering based on content and connection structure"
% minimize ||X-WH||_F^2 + alpha*||S-Hhat'*H||_F^2 + beta*||Hhat - H||_F^2
% where X,S>=0 elementwise.
%
%<Inputs>
%   X: matrix size m * n
%   S: matrix size n * n
%   k: number of features
%   maxitr: max iteration times
%   alpha,beta: parameters for function (8)
%<Outputs>
%   W: matrix size m * k
%   H: matrix size k * n
function [W,H]=clustering(X,S,k,maxitr,alpha,beta)
    [m,n]=size(X);

    % using random initial value
    %H=rand(k,n);
    %Hhat=rand(k,n);
    %W=rand(m,k);
    
    % instead of using initial value for W and H
    % here using the nmf matrix W,H of matrix X as initial
    [W,H]=nmf(X,k);
    Hhat=H;
    
    %identical matrix and sqrt(alpha), sqrt(beta)
    Ik=diag(ones(k,1));
    alpha2=sqrt(alpha);
    beta2=sqrt(beta);
    
    for i=1:maxitr
        % equation (9) from paper
        [ wt,Y,iter,success ] = nnlsm_blockpivot(H',X');
        %[ wt,Y,iter,success ] = nnlsm_activeset(H',X');
        W=wt';
        
        % equation (10) from paper
        m1=[alpha2*H';beta2*Ik];
        m2=[alpha2*S;beta2*H];
        [ Hhat,Y,iter,success ] = nnlsm_blockpivot(m1,m2);
        %[ Hhat,Y,iter,success ] = nnlsm_activeset(m1,m2);
        
        % equation (11) from paper
        m1=[W;alpha2*Hhat';beta2*Ik];
        m2=[X;alpha2*S;beta2*Hhat];
        [ H,Y,iter,success ] = nnlsm_blockpivot(m1,m2);
        %[ H,Y,iter,success ] = nnlsm_activeset(m1,m2);
    end
    