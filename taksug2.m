function g=taksug2(y,X,a,b)
% Version 14/11/2012
% Alfredo Núñez & Doris Sáez
% Suggestions to dsaez@ing.uchile.cl

% Identification of the consequences
% Global optimization of the T&S 
% y, X are the output and the regressors
% a, b define the MF Gaussians of the clusters

% In case the parameters are overtuned, try taksug3 that optimizes each TS
% rules, so the parameters have better coeficients

[N,n]=size(X); 
NR=size(a,1);  
A=[];

for k=1:N  
   W=ones(1,NR);
   for r=1:NR
    for i=1:n
      W(r)=W(r)*exp(-0.5*(a(r,i)*(X(k,i)-b(r,i)))^2);
    end
   end

  Wn=W/sum(W);

  Aux2=[];
  for r=1:NR
    Aux=[];
    Aux(1,1)=Wn(r);
    for i=1:n
    Aux(1,i+1)=Wn(r)*X(k,i);
    end
    Aux2=[Aux2,Aux];
  end
   A(k,:)=Aux2;
end
  
p=A\y;

cont=1;
for r=1:NR
    g(r,:)=p(cont:cont+n,1)';
    cont=cont+n+1;
end

