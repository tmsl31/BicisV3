function g=taksug1(y,X,a,b)
% Version 14/11/2012
% Alfredo Núñez & Doris Sáez
% Suggestions to dsaez@ing.uchile.cl

% Identification of the consequences
% Each rule of the T&S is identified separetely 
% y, X are the output and the regressors
% a, b define the MF Gaussians of the clusters

% Data close to the center of clusters is more important in the objective
% function, so they are more relevant when obtaining the local functions


[N,n]=size(X); 
NR=size(a,1);  

for r=1:NR
    
A=[];
yr=[];
Wrr=[];  


  for k=1:N %N is the number of data points
  W=1;
  for i=1:n
      W=W*exp(-0.5*(a(r,i)*(X(k,i)-b(r,i)))^2);
  end
  
      A(k,1)=W;
      yr(k)=W*y(k);
      for i=1:n
      A(k,i+1)=W*X(k,i);
      end
  end

yii=yr';
p=A\yii;
g(r,:)=p';

end

