function y=ysim2(X,a,b,P,std_j)

% y is the vector of outputs 
% X is the data matrix Input

% n is the number of regressors of the TS model
n=size(X,2);

% NR is the number of rules of the TS model
NR=size(a,1);         
   
    % W(r) is the activation degree of the rule r
    % mu(r,i) is the activation degree of rule r, regressor i
    W=ones(1,NR);
    mu=zeros(NR,n);
    for r=1:NR
        for i=1:n
            mu(r,i)=exp(-0.5*(a(r,i)*(X(i)-b(r,i)))^2);
            W(r)=W(r)*mu(r,i);
        end
    end
   
    % Wn(r) is the normalized activation degree
    Wn=W/sum(W);
    
    %X(:,end)=zeros(size(X,1),1);
    
    phi_l=kron(Wn',[1 ,X]);
    
    y=0;
    for j=1:NR
     extra(j)=sqrt(std_j(j))*sqrt(1+phi_l(j,:)*P(:,:,j)*phi_l(j,:)');
     y=y+Wn(j)*extra(j);
    end
%     y=sum(extra);

end
     