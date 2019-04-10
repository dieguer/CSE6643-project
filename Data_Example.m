clear
%Code to create the example matrices:
%Two matrices: (mxn) matrix X conteining features and (nxn) matrix S containing the network
%The minimization probles are given by: min||X-WH|| and min||S-H^tH|| where W is (mxk) and H is (kxn)

%We need to decide sample size n, features m, and clusters k
n=10;
m=20;
k=4;

%One approach is to just create random matrices W and H such that X=WH and S=H^tH
rng(106,'twister');
s=rng;
%W = randi([100,1000],m,n);
W = rand(m,k);
H = rand(k,n);
X = W*H;
S = H.'*H;

%Another approach is to create W and H with a particular structure
%If one element in W1 is possitive, it is negative in W2,W3 and W4
D=rand(k,n);
for j=1:k
    mn = min(D(j,1:end));
    for i=1:n
        D(j,i)=D(j,i)==mn;
    end
end

Ht=H.*D;
w=randi(20,m,k);
Wt=w./sum(w);

Xt = Wt*Ht
St = Ht.'*Ht;