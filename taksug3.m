function g=taksug3(y,X,a,b)
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
cont=1;
Wrr=[];  


while(cont<=n) 
%n is the number of regressors, if we have less data available than regressors
%thi condition is relaxed later
    Wk=0.000000001; %0.0001; % Data with a very low membership degree is not considered

  for k=1:N %N is the number of data points
  W=1;
  for i=1:n
      W=W*exp(-0.5*(a(r,i)*(X(k,i)-b(r,i)))^2);
  end
  
  if(W>=Wk)
      A(cont,1)=W;
      yr(cont)=W*y(k);
      for i=1:n
      A(cont,i+1)=W*X(k,i);
      end
      cont=cont+1;
  end
end

%In case there are less than 5 data points available, the threshold of the MF 
% values is reduced, so to include more points
if(cont<=5)
Wk=0.001*Wk; 
end

end

yii=yr';
p=A\yii;
g(r,:)=p';

end

