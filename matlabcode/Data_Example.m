clear
%Code to create the example matrices:
%Two matrices: (mxn) matrix X conteining features and (nxn) matrix S containing the network
%The minimization probles are given by: min||X-WH|| and min||S-H^tH|| where W is (mxk) and H is (kxn)

%We need to decide sample size n, features m, and clusters k
n=500;
m=10000;
k=6;

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
for j=1:n
    mn = min(D(1:end,j));
    for i=1:k
        D(i,j)=D(i,j)==mn;
    end
end

Ht=H.*D;
%w=randi(20,m,k);
%Wt=w./sum(w);
Wt=randi(20,m,k)

Xt = Wt*Ht;
St = Ht.'*Ht;

%Algorithms
%Define parameters
alpha=norm(X,'fro')^2/norm(S,'fro')^2;
beta=alpha*max(max(S));

alphac=norm(Xt,'fro')^2/norm(St,'fro')^2;
betac=alpha*max(max(St));

%Define values for the loop
inc=10;
iv=10;
fv=100;

%Random matrix
Rw=zeros(fv/inc,1);
Rh=Rw;
Rb=Rw;
count=0;
for i=iv:inc:fv
    count=count+1;
    Rb(count)=i;
    maxitr=i;
    [Wp,Hp]=clustering(X,S,k,maxitr,alpha,beta);
    Rw(count,1)=norm(W,'fro')-norm(Wp,'fro');
    Rh(count,1)=norm(H,'fro')-norm(Hp,'fro');
end

plot(Rb,Rw)
hold on
plot(Rb,Rh)
hold off


hist(clustmem(H))
hist(clustmem(Hp))


%% 

%Clustered matrix
Rwc=zeros(fv/inc,1);
Rhc=Rwc;
Rb=Rwc;
count=0;
for i=iv:inc:fv
    count=count+1;
    Rb(count)=i;
    maxitr=i;
    [Wtp,Htp]=clustering(Xt,St,k,maxitr,alphac,betac);
    Rwc(count,1)=norm(Wt,'fro')-norm(Wtp,'fro');
    Rhc(count,1)=norm(Ht,'fro')-norm(Htp,'fro');
end

plot(Rb,Rwc)
hold on
plot(Rb,Rhc)
hold off


hist(clustmem(Htp))
hist(clustmem(Ht))

%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Real Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_real=dlmread("S_matrix.csv");
X_real=dlmread("X_matrix.csv");
X_real=X_real.'
alpha_r=norm(X_real,'fro')^2/norm(S_real,'fro')^2;
beta_r=alpha_r*max(max(S_real));

k=20;
[W_real,H_real]=clustering(X_real,S_real,k,200,alpha_r,beta_r);

clustmem(H_real)

ceros=find(sum(S_real,2)~=0)

S_R=S_real(ceros,ceros)

X_R=X_real(:,ceros)

alpha_R=norm(X_R,'fro')^2/norm(S_R,'fro')^2;
beta_R=alpha_R*max(max(S_R));

k=40

kas=[ 10 15 20 30 ]

for i=1:4
[W_R,H_R]=clustering(X_R,S_R,kas(i),500,alpha_R,beta_R);
gfc=figure
hist(clustmem(H_R))
hold on
saveas(gcf,sprintf('/home/diegolog/Documents/CSE 6643/project/CSE6643-project/FIG%d.png',i))
end

