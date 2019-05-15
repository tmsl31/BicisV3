function y=incerteza(X,Y,model)

a = model.a;
b = model.b;
P = model.P;

std_j = calculoSigma(model,X,Y,1);
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
    
    phi_l=kron(Wn',[ones(size(X,1),1) ,X]);
    
    y=0;
    for j=1:NR
     extra(j)=sqrt(std_j(j))*sqrt(1+phi_l(j,:)*P(:,:,j)*phi_l(j,:)');
     y=y+Wn(j)*extra(j);
    end
%     y=sum(extra);

end

% function [vecIr, I] = incerteza(XTest,YTest,model)
%     %Funcion que realice el calculo de la incerteza del modelo.
%     %Equivalente a ysim2 pero programa de otra manera.
%     
%     %Parametros del modelo.
%     a = model.a;
%     b = model.b;
%     g = model.g;
%     P = model.P;
%     h = model.h;
%     
%     %Numero de regresores del utilizados por el modelo de Takagi & Sugeno.
%     [nDatos,nRegresores] = size(XTest);
%     %Numero de reglas del modelo de TS.
%     nReglas = size(a,1);
%     %Vector de incertezas de reglas.
%     vecIr = zeros(1,nReglas);
%     
%     %Calculo de grados de activacion por regla
%     %wn(r) es el grado de activacion de la regla r.
%     %mu(r,i) es el grado de activacion para la regla r ante la entrada i.
%     w = ones(1,nReglas);
%     mu = zeros(nReglas,nRegresores);
%     for regla = 1:nReglas
%        %Por cada regla
%        for entrada = 1:nRegresores
%            %Grado de activacion para cada entrada.
%            mu(regla,entrada) = gaussiana(b(regla,entrada),a(regla,entrada),XTest(entrada));
%            %Grado de activacion de la regla para la muestra.
%            w(regla) = w(regla) * mu(regla,entrada);
%        end
%     end
% 
%    %Normalizacion de los grados de activacion.
%    wn=activacionNorm(w);
%    
%    %Calculo de sigma.
%    sigma = calculoSigma(model,XTest,YTest,1);
%    
%    %Matriz psi
%    psi = w'*[ones(nDatos,1), XTest];
%    
%    %Incerteza total del modelo.
%    I = 0;
%    %Calculo de las incertezas. Numero es el numero de reglas.
%    for regla = 1:1:nReglas
%        %Calculo de la incerteza por regla
%        disp(size(sigma))
%        disp(size(psi))
%        disp(size(P(:,:,1)))
%        Ir = sqrt(sigma(regla)) * sqrt(psi(regla,:) * P(:,:,regla)* transpose(psi(regla,:)));
%        disp(size(Ir))
%        %Agregar al vector de regla.
%        vecIr(regla) = Ir;
%        %Construccion de incerteza total.
%        I = I + wn(regla) * Ir;
%    end
% end



%% Funciones Auxiliares.

function [valor] = gaussiana(mu,sigma,x)
    %Funcion que evalue la funcion gaussiana.

    valor = exp(-0.5*(sigma*(x-mu))^2);
end

function [Wn] = activacionNorm(W)
    %Activacion normalizada de la regla.
    if (sum(W)==0)
        Wn = W;
    else
        Wn = W/sum(W);
    end   
end